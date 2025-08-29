#!/bin/bash
set -Eeuo pipefail

source .config

: ${PLX_DEV:?"PLX Device Not Set"}
: ${PLX:?"PLX Path Not Set"}

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source $SRC_DIR/common.sh
source $SRC_DIR/plx_common.sh

sudo mkdir -p $PLX/usr/share/plx/patches/

sudo cp $SRC_DIR/plx_common.sh $PLX/usr/share/plx/tmp/
sudo cp $SRC_DIR/../modules/bin-releases/*.patch $PLX/usr/share/plx/patches/

#unmount virtual stuff if already mounted, just to be safe...
plx_umount_virt

source $SRC_DIR/cross_build.sh

source $SRC_DIR/build.env

if [ ! -f .status ]; then
    read -p "Status file not found, start from scratch? (y/n) " answer

    case "$answer" in
        [Yy]* ) touch .status ;;
        [Nn]* ) exit -1 ;;
        * ) exit -1 ;;
    esac

    echo "Starting new build..."
fi

set_root_pw() {
    sudo chroot "$PLX" /usr/bin/env -i   \
            HOME=/root                  \
            PS1='(lfs chroot) \u:\w\$ ' \
            PATH=/usr/bin:/usr/sbin     \
            MAKEFLAGS="-j$(nproc)"      \
            TESTSUITEFLAGS="-j$(nproc)" \
            /bin/bash --login -e -c "passwd root"
}

do_install_process() {
    set -e
    process="${1:?}"

    if $(pck_installed $process) ; then
        echo "Skipping $process..."
        return 0
    fi

    "$process"

    echo "$process" | sudo tee -a $PLX$PLX_INSTALLED > /dev/null
}

create_user_if_none() {
    user=$(awk -F: '$3 == 1000 {print $1, $3}' $PLX/etc/passwd)

    if [ "$user" == "" ]; then
        echo "Creating admin user..."

        read -rp "Enter the new username: " username

        if [[ -z "$username" ]]; then
            echo "No username entered, aborting." >&2
            exit -1
        fi

        sudo chroot "$PLX" /usr/bin/env -i   \
            HOME=/root                  \
            PS1='(lfs chroot) \u:\w\$ ' \
            PATH=/usr/bin:/usr/sbin     \
            MAKEFLAGS="-j$(nproc)"      \
            TESTSUITEFLAGS="-j$(nproc)" \
            /bin/bash --login -e -c "useradd -m -G wheel $username; usermod -aG netdev $username || true; passwd $username"

    fi
}

build_packages() {
    for pck in $(cat $SRC_DIR/$1.lst)
    do
        build_inst_pck $pck
    done;
}

plx_mount_virt

build_packages base-system

build_packages base-dev

build_packages base-ui

#build_packages base-lxqt

build_packages base-kde

#
do_install_process set_root_pw
#
create_user_if_none

plx_umount_virt
