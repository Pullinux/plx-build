
PCKDIR=/usr/share/plx/tmp/inst/
SCRIPT_PATH="$(realpath "${BASH_SOURCE[0]}")"

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

build_package() {
	archive=$1
	func=$2

	local step="$func"

	if step_is_done "$step"; then
	  echo "==> Skipping ${step} (already done)"
	  return 0
	fi

	echo "==> Running ${step}..."

	sudo rm -rf "$PLX/usr/share/plx/tmp/inst"
	sudo mkdir -p "$PLX/usr/share/plx/tmp/inst"

	plx_prep_release_build $archive
	run_in_chroot plx_common.sh $func

	SP=$(tar -tf "modules/bin-releases/$1" | awk -F/ '{print $1}' | head -1 || true)

	sudo rm -rf "$PLX/usr/share/plx/tmp/$SP"

	echo "Building package in $PLX$PCKDIR"

	pushd $PLX$PCKDIR
	sudo tar -cJpf $PLX/usr/share/plx/bin/$SP-pck.txz * 
	popd
	
	mark_step_done "$step"
}



if [[ -n "${1:-}" ]]; then
        "$1"
fi

