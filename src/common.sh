#!/bin/sh

STATUS_FILE=.status
BUILD_USER=$(whoami)

init_module() {
    git submodule update --init --remote --depth 1 modules/$1
}

deinit_module() {
    git submodule deinit -f modules/$1
    rm -rf .git/modules/modules/$1
}

git_init() {
    git init
    find . -name "*.gitignore" -exec rm {} \;
    git add .
    git commit -m "first commit"
    git branch -M master
    git remote add origin https://github.com/Pullinux/plx-$1.git
    git push -u origin master

    echo "Waiting for init..."
    sleep 5

    cd ~/git/plx-build
    git submodule add https://github.com/Pullinux/plx-$1.git modules/$1

    git submodule set-branch --branch master modules/$1
    git submodule sync modules/$1

    deinit_module $1
    du -sh .
}

step_is_done() {
  local step="$1"
  grep -Fqx -- "$step" "$STATUS_FILE"
}

mark_step_done() {
  local step="$1"
  sed -i "\|^${step}\$|d" "$STATUS_FILE"
  printf '%s\n' "$step" >> "$STATUS_FILE"
}

run_step() {
  local step="$1"
  if step_is_done "$step"; then
    echo "==> Skipping ${step} (already done)"
    return 0
  fi
  echo "==> Running ${step}..."

  if [[ -n "${1:-}" ]]; then
	  "$step" "$1"
  else
  	"$step"    # call the function
  fi
  
  mark_step_done "$step"
}

plx_format() {
    sudo mkfs.ext4 -v $PLX_DEV
}

plx_mount() {
    sudo mkdir -p $PLX
    sudo mount $PLX_DEV $PLX
}

plx_init() {
    sudo chown root:root $PLX
    sudo chmod 755 $PLX
}

plx_create_paths() {
    sudo mkdir -pv $PLX/{etc,var,tools,lib64} $PLX/usr/{bin,lib,sbin}
    
    for i in bin lib sbin; do
        sudo ln -sv usr/$i $PLX/$i
    done

    sudo chown -v $BUILD_USER $PLX/{usr{,/*},var,etc,tools,lib64}
}

plx_prep_virt() {
	sudo chown -R root:root $PLX/{usr,lib,var,etc,bin,sbin,tools,lib64}
	sudo mkdir -pv $PLX/{dev,proc,sys,run}
	sudo mkdir -pv $PLX/usr/share/plx/{bin,tmp,src}
}

plx_mount_virt() {

	: "${PLX:?}"

	if ! mountpoint -q "$PLX/dev"; then
		sudo mount -v --bind /dev "$PLX/dev"
	fi

	if ! mountpoint -q "$PLX/dev/pts"; then
		sudo mount -vt devpts devpts -o gid=5,mode=0620 $PLX/dev/pts
	fi

	if ! mountpoint -q "$PLX/proc"; then
		sudo mount -vt proc proc $PLX/proc
	fi

	if ! mountpoint -q "$PLX/sys"; then
                sudo mount -vt sysfs sysfs $PLX/sys
        fi

	if ! mountpoint -q "$PLX/run"; then
                sudo mount -vt tmpfs tmpfs $PLX/run
        fi

	if [ -h $PLX/dev/shm ]; then
	  sudo install -v -d -m 1777 $PLX$(realpath /dev/shm)
  	elif ! mountpoint -q "$PLX/dev/shm"; then
	  sudo mount -vt tmpfs -o nosuid,nodev tmpfs $PLX/dev/shm
	fi

}

plx_umount_virt() {

	: "${PLX:?}"

	sudo mountpoint -q $PLX/dev/shm && sudo umount $PLX/dev/shm

	if mountpoint -q "$PLX/dev/pts"; then
              sudo umount $PLX/dev/pts
        fi

        if mountpoint -q "$PLX/proc"; then
                sudo umount  $PLX/proc
        fi

        if mountpoint -q "$PLX/sys"; then
                sudo umount $PLX/sys
        fi

        if mountpoint -q "$PLX/run"; then
                sudo umount $PLX/run
        fi

        if mountpoint -q "$PLX/dev"; then
                sudo umount $PLX/dev
        fi

}

run_in_chroot() {
	sudo cp $SRC_DIR/$1 ${PLX:?}/usr/share/plx/tmp/

	sudo mkdir -p $PLX/usr/share/plx/tmp/inst

	sudo touch $PLX/usr/share/plx/tmp/prep.sh

	sudo cp $SRC_DIR/env.sh $PLX/usr/share/plx/bin/

	func_param=""

	if [[ -n "${3:-}" ]]; then
		func_param="$3"
		echo "RIC: Param: $func_param"
	fi


	echo "Running chroot: $1 - $2 - $func_param"

	sudo chroot "$PLX" /usr/bin/env -i   \
	    HOME=/root                  \
	    TERM="$TERM"                \
	    PS1='(lfs chroot) \u:\w\$ ' \
	    PATH=/usr/bin:/usr/sbin     \
	    MAKEFLAGS="-j$(nproc)"      \
	    TESTSUITEFLAGS="-j$(nproc)" \
	    /bin/bash --login -c "cd /usr/share/plx/tmp/ && . /usr/share/plx/bin/env.sh && . /usr/share/plx/tmp/prep.sh && . /usr/share/plx/tmp/$1 && $2 $func_param"

	sudo rm ${PLX:?}/usr/share/plx/tmp/$1
}

plx_user_setup() {
    echo "nothing"
}

plx_fs_setup() {
	run_in_chroot chr_util.sh fs_setup
}

plx_create_init_config() {
	run_in_chroot chr_util.sh create_init_config
}

plx_prep_release_build() {
	SP=$(tar -tf "modules/bin-releases/$1" | awk -F/ '{print $1}' | head -1 || true)

	sudo cp modules/bin-releases/$1 $PLX/usr/share/plx/tmp/

	pushd $PLX/usr/share/plx/tmp/	
	sudo tar -xf $1
	sudo rm $1

	popd

	echo "cd $SP" | sudo tee $PLX/usr/share/plx/tmp/prep.sh > /dev/null
}

plx_build_module_chr() {
	init_module $1
	sudo cp -r modules/$1 $PLX/usr/share/plx/tmp/
	deinit_module $1

	run_in_chroot chr_util.sh $2
}

plx_build_gettext() {
	plx_prep_release_build "gettext-0.24.tar.xz"
	run_in_chroot chr_util.sh "build_gettext"
}

plx_build_bison() {
	plx_prep_release_build bison-3.8.2.tar.xz
        run_in_chroot chr_util.sh build_bison
}

plx_build_perl() {
	plx_prep_release_build perl-5.40.1.tar.xz
        run_in_chroot chr_util.sh build_perl
}


plx_build_python() {
        plx_prep_release_build Python-3.13.2.tar.xz
        run_in_chroot chr_util.sh build_python
}

plx_build_texinfo() {
        plx_prep_release_build texinfo-7.2.tar.xz
        run_in_chroot chr_util.sh build_texinfo
}

plx_build_utillinux() {
        plx_prep_release_build util-linux-2.40.4.tar.xz
        run_in_chroot chr_util.sh build_utillinux
}

plx_build_beecrypt() {
	plx_prep_release_build beecrypt-4.1.2.tar.gz
        run_in_chroot chr_util.sh build_beecrypt
}

plx_build_neon() {
	plx_prep_release_build neon-0.35.0.txz
        run_in_chroot chr_util.sh build_neon
}

plx_build_rpm() {
	plx_prep_release_build rpm-4.20.1.tar.bz2
	run_in_chroot chr_util.sh build_rpm
}

plx_cross_cleanup() {
	sudo rm -rf ${PLX:?}/usr/share/{info,man,doc}/*
	sudo find $PLX/usr/{lib,libexec} -name \*.la -delete
	sudo rm -rf $PLX/tools
}

plx_cross_backup() {
	sudo tar -cJpf plx-temp-tools.txz -C ${PLX:?}/ .
}

# /usr/bin/trust extract --filter=ca-anchors --format=openssl-directory --overwrite --comment ""
