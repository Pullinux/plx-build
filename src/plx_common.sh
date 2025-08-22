PLX_ROOT=/usr/share/plx
PLX_INSTALLED=$PLX_ROOT/installed

PCKDIR=/usr/share/plx/tmp/inst/
SCRIPT_PATH="$(realpath "${BASH_SOURCE[0]}")"
SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PCK_ROOT="$SRC_DIR/../packages"

prep_release_build() {
        SP=$(tar -tf "modules/bin-releases/$1" | awk -F/ '{print $1}' | head -1 || true)

        sudo cp modules/bin-releases/$1 $PLX/usr/share/plx/tmp/

        pushd $PLX/usr/share/plx/tmp/
        sudo tar -xf $1
        sudo rm $1

        popd

        echo "cd $SP" | sudo tee $PLX/usr/share/plx/tmp/prep.sh > /dev/null
}

build_pck_manpages() {
	echo "Building manpages... $(pwd)"

	rm -v man3/crypt*

	make -R GIT=false prefix=/usr DESTDIR=$PCKDIR install
}

build_pck_ianaetc() {
	mkdir -p $PCKDIR/etc
	cp services protocols $PCKDIR/etc
}

copy_glib_files() {
	sudo mkdir -p $PLX/usr/share/plx/tmp/inst/.install

	sudo cp modules/bin-releases/glibc-2.41-fhs-1.patch $PLX/usr/share/plx/tmp/
	sudo cp modules/bin-releases/tzdata2025a.tar.gz $PLX/usr/share/plx/tmp/inst/.install/
	
sudo tee $PLX/usr/share/plx/tmp/inst/.install/install.sh > /dev/null << "EOF"

localedef -i C -f UTF-8 C.UTF-8
localedef -i en_US -f ISO-8859-1 en_US
localedef -i en_US -f UTF-8 en_US.UTF-8

tar -xf tzdata2025a.tar.gz

ZONEINFO=/usr/share/zoneinfo
mkdir -pv $ZONEINFO/{posix,right}

for tz in etcetera southamerica northamerica europe africa antarctica  \
          asia australasia backward; do
    zic -L /dev/null   -d $ZONEINFO       ${tz}
    zic -L /dev/null   -d $ZONEINFO/posix ${tz}
    zic -L leapseconds -d $ZONEINFO/right ${tz}
done

cp -v zone.tab zone1970.tab iso3166.tab $ZONEINFO
zic -d $ZONEINFO -p America/New_York

ln -sfv /usr/share/zoneinfo/America/Chicago /etc/localtime

EOF




}

build_pck_glibc() {
	set -e

	patch -Np1 -i /usr/share/plx/patches/glibc-2.41-fhs-1.patch

	mkdir build && cd build

	echo "rootsbindir=/usr/sbin" > configparms

	ls -l /dev/null

	echo ""
	echo "configuring..."
	echo ""

	../configure --prefix=/usr                            \
             --disable-werror                         \
             --enable-kernel=5.4                      \
             --enable-stack-protector=strong          \
             --disable-nscd                           \
             libc_cv_slibdir=/usr/lib

	echo ""
        echo "making..."
        echo ""

	make

	mkdir -p $PCKDIR/etc

	touch $PCKDIR/etc/ld.so.conf

	make DESTDIR=$PCKDIR install

	sed '/RTLDLIST=/s@/usr@@g' -i $PCKDIR/usr/bin/ldd

cat > $PCKDIR/etc/nsswitch.conf << "EOF"
# Begin /etc/nsswitch.conf

passwd: files systemd
group: files systemd
shadow: files systemd

hosts: mymachines resolve [!UNAVAIL=return] files myhostname dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

# End /etc/nsswitch.conf
EOF

cat > $PCKDIR/etc/ld.so.conf << "EOF"
# Begin /etc/ld.so.conf
/usr/local/lib
/opt/lib
# Add an include directory
include /etc/ld.so.conf.d/*.conf

EOF

	mkdir -pv $PCKDIR/etc/ld.so.conf.d

}

build_pck_zlib() {
	./configure --prefix=/usr
	make
	make DESTDIR=$PCKDIR install
	rm -fv $PCKDIR/usr/lib/libz.a
}



build_package() {
	archive=$2
	func=$1

	sudo rm -rf "$PLX/usr/share/plx/tmp/inst"
	sudo mkdir -p "$PLX/usr/share/plx/tmp/inst"

	if [[ -n "${3:-}" ]]; then
                "$3"
        fi

	plx_prep_release_build $archive
	run_in_chroot plx_common.sh $func

	sudo rm -rf $PLX/usr/share/plx/tmp/prep.sh

	SP=$(tar -tf "modules/bin-releases/$archive" | awk -F/ '{print $1}' | head -1 || true)

	sudo rm -rf "$PLX/usr/share/plx/tmp/$SP"

	echo "Building package in $PLX$PCKDIR"

	pushd $PLX$PCKDIR
	(
		shopt -s dotglob nullglob
		sudo tar -cJpf $PLX/usr/share/plx/bin/$SP-pck.txz *
	)
	popd
}

run_install() {
	set -e

	rm -rf /.install

	echo "Installing $1..."

	cd /
	tar -xhf $1 

	if [ -f /.install/install.sh ]; then
		cd /.install
		echo "Running installer..."
		ls -lsa
		bash -e install.sh
		rm -rf /.install
		echo "Install Complete"
	else
		echo "No installer"
	fi
}

install_package() {
        archive=$1

        SP=$(tar -tf "modules/bin-releases/$archive" | awk -F/ '{print $1}' | head -1 || true)

	run_in_chroot plx_common.sh run_install /usr/share/plx/bin/$SP-pck.txz

	#sudo chroot "$PLX" /usr/bin/env -i   \
        #    PATH=/usr/bin:/usr/sbin     \
        #    /bin/bash --login -c "cd / && tar -xhf /usr/share/plx/bin/$SP-pck.txz"

}

run_build_step() {
  local step="_plx_$1_$2"
  if step_is_done "$step"; then
    echo "==> Skipping ${step} (already done)"
    return 0
  fi
  
  echo "==> Running ${step}..."

  build_param=""

  if [[ -n "${4:-}" ]]; then
	build_param="$4"
  fi

	if [ "$1" == "build" ]; then
		build_package "build_$2" $3 $build_param
	elif [ "$1" == "install" ]; then
		install_package $3
	fi

  mark_step_done "$step"
}

pck_get_version() {
	pck=$1
	pck_path=$PCK_ROOT/${pck:0:1}/$pck

	source $pck_path/pck

	echo "$version"
}

pck_get_source() {
	pck=$1
	pck_path=$PCK_ROOT/${pck:0:1}/$pck

	source $pck_path/pck

	echo "$source"
}

pck_installed() {
	sudo touch "$PLX$PLX_INSTALLED"
	grep -Fqx -- "$1" "$PLX$PLX_INSTALLED"
}

chroot_build() {
	sudo mkdir -p $PLX/usr/share/plx/tmp/inst

	sudo touch $PLX/usr/share/plx/tmp/prep.sh

	sudo cp $SRC_DIR/env.sh $PLX/usr/share/plx/bin/

	echo "Exec chroot: $1"

	sudo chroot "$PLX" /usr/bin/env -i   \
	    HOME=/root                  \
	    PS1='(lfs chroot) \u:\w\$ ' \
	    PATH=/usr/bin:/usr/sbin     \
	    MAKEFLAGS="-j$(nproc)"      \
	    TESTSUITEFLAGS="-j$(nproc)" \
	    /bin/bash --login -e -c "cd /usr/share/plx/tmp/ && . /usr/share/plx/bin/env.sh && . /usr/share/plx/tmp/prep.sh && bash -e $1"

}

build_pck() {
	pck=$1
	pck_path=$2
	version=$3
	source=$(pck_get_source $pck)

	echo "Building package $pck $version..."

	#cleanup first...
	sudo rm -rf ${PLX:?}${PLX_ROOT:?}/tmp/$pck
	sudo rm -rf ${PLX:?}${PLX_ROOT:?}/tmp/inst
	sudo mkdir -p ${PLX:?}${PLX_ROOT:?}/tmp/inst
	sudo cp -r $pck_path $PLX$PLX_ROOT/tmp/

	cd $PLX$PLX_ROOT/tmp/$pck

	echo "export PCKBASE=$PLX_ROOT/tmp/$pck" | sudo tee $PLX/usr/share/plx/tmp/prep.sh > /dev/null
	echo "export PCKDIR=$PLX_ROOT/tmp/inst" | sudo tee -a $PLX/usr/share/plx/tmp/prep.sh > /dev/null
	echo "cd $PLX_ROOT/tmp/$pck" | sudo tee -a $PLX/usr/share/plx/tmp/prep.sh > /dev/null
	
	if [ "$source" != "" ]; then
		sudo tar -xf files/$source

		SP=$(tar -tf files/$source | head -1 || true)
		SP=$(echo $SP | awk -F/ '{print $1}')

		echo "cd $SP" | sudo tee -a $PLX/usr/share/plx/tmp/prep.sh > /dev/null
	fi

	if [ ! -f build.sh ]; then
		echo "No build file..."
	else
		echo "Running build in chroot..."

		sudo chmod u+x build.sh
		chroot_build "../build.sh"
	fi

	if [ ! -d install ]; then
		echo "No installer..."
	else
		echo "Copying installer..."
		sudo mkdir -p $PLX$PLX_ROOT/tmp/inst/.install
		sudo cp -r install/* $PLX$PLX_ROOT/tmp/inst/.install
	fi

	if [ -z "$(ls -A $PLX$PLX_ROOT/tmp/inst)" ]; then
    	echo "No files to package!"
		exit -1
	else
		echo "Creating package $pck-$version-plx-1.0.txz..."
		pushd $PLX$PCKDIR
		(
			shopt -s dotglob nullglob
			sudo tar -cJpf $PLX$PLX_ROOT/bin/$pck-$version-plx-1.0.txz *
		)
		popd

		echo "Package build complete for $pck $version"
	fi

	#cleanup last
	sudo rm -rf ${PLX:?}${PLX_ROOT:?}/tmp/$pck

}

install_pck() {
	pck=$1
	version=$2

	sudo cp $SRC_DIR/env.sh $PLX/usr/share/plx/bin/

	sudo rm -rf $PLX/.install

	echo "Installing $PLX_ROOT/bin/$pck-$version-plx-1.0.txz"

	cd ${PLX:?}/
	sudo tar -xhf $PLX$PLX_ROOT/bin/$pck-$version-plx-1.0.txz

	if [ -f $PLX/.install/install.sh ]; then
		echo "Running installer..."

		sudo chroot "$PLX" /usr/bin/env -i   \
			HOME=/root                  \
			PS1='(lfs chroot) \u:\w\$ ' \
			PATH=/usr/bin:/usr/sbin     \
			MAKEFLAGS="-j$(nproc)"      \
			TESTSUITEFLAGS="-j$(nproc)" \
			/bin/bash --login -e -c "cd /.install && bash -e install.sh"

		sudo rm -rf $PLX/.install
	fi

	echo "$pck" | sudo tee -a $PLX$PLX_INSTALLED > /dev/null

	echo "Done installing $pck $version"
}

build_inst_pck() {
	pck=$1
	pck_path=$PCK_ROOT/${pck:0:1}/$pck

	sudo mkdir -p $PLX$PLX_ROOT/tmp/inst

	if [ ! -d $pck_path ]; then
		echo "package not found: $pck ($pck_path)"
		exit -1
	fi

	if $(pck_installed $pck) ; then
		echo "Package $pck already installed."
		return 0
	fi

	echo "Getting version..."
	version=$(pck_get_version $pck)

	if [ ! -f $PLX$PLX_ROOT/bin/$pck-$version-plx-1.0.txz ]; then
		build_pck $pck $pck_path $version
	fi

	install_pck $pck $version
}

if [[ -n "${1:-}" ]]; then
        "$1"
fi

