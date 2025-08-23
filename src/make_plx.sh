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

cleanup_files() {
    sudo rm -rf $PLX/tmp/{*,.*}
    sudo find $PLX/usr/lib $PLX/usr/libexec -name \*.la -delete
    sudo find $PLX/usr -depth -name $(uname -m)-plx-linux-gnu\* | xargs sudo rm -rf
}

do_init_config() {
	sudo ln -s /dev/null $PLX/etc/systemd/network/99-default.link

	sudo tee $PLX/etc/systemd/network/10-eth-dhcp.network > /dev/null << "EOF"
[Match]
Name=eth0

[Network]
DHCP=ipv4

[DHCPv4]
UseDomains=true
EOF

	
	echo "plx" > sudo tee $PLX/etc/hostname > /dev/null
	echo "127.0.0.1 localhost" > sudo tee $PLX/etc/hosts > /dev/null

	sudo tee $PLX/etc/adjtime > /dev/null << "EOF"
0.0 0 0.0
0
LOCAL
EOF

	sudo tee $PLX/etc/fstab > /dev/null << EOF

$PLX_DEV	/	ext4	defaults	1	1

EOF




}

finish_initial_config() {
	echo 1.0 > sudo tee $PLX/etc/plx-release > /dev/null
	sudo tee $PLX/etc/lsb-release > /dev/null << "EOF"
DISTRIB_ID="Pullinux"
DISTRIB_RELEASE="1.0"
DISTRIB_CODENAME="LLD"
DISTRIB_DESCRIPTION="Pullinux"
EOF

	sudo tee $PLX/etc/os-release > /dev/null << "EOF"
NAME="Pullinux"
VERSION="1.0"
ID=plx
PRETTY_NAME="Pullinux 1.0"
VERSION_CODENAME="lld"
HOME_URL="https://github.com/rockytriton"
RELEASE_TYPE="stable"
EOF

	sudo chroot "$PLX" /usr/bin/env -i   \
            HOME=/root                  \
            PS1='(lfs chroot) \u:\w\$ ' \
            PATH=/usr/bin:/usr/sbin     \
            MAKEFLAGS="-j$(nproc)"      \
            TESTSUITEFLAGS="-j$(nproc)" \
            /bin/bash --login -e -c "passwd root"

}

do_install_process() {
    process="${1:?}"

    if $(pck_installed $process) ; then
        echo "Skipping $process..."
        return 0
    fi

    "$process"

    echo "$process" | sudo tee -a $PLX$PLX_INSTALLED > /dev/null
}

plx_mount_virt

build_inst_pck man-pages
build_inst_pck iana-etc
build_inst_pck glibc
build_inst_pck zlib
build_inst_pck bzip2
build_inst_pck xz
build_inst_pck lz4
build_inst_pck zstd
build_inst_pck file
build_inst_pck readline
build_inst_pck m4
build_inst_pck bc
build_inst_pck flex
build_inst_pck tcl
build_inst_pck expect
build_inst_pck dejagnu
build_inst_pck pkgconf
build_inst_pck binutils
build_inst_pck gmp
build_inst_pck mpfr
build_inst_pck mpc
build_inst_pck attr
build_inst_pck acl
build_inst_pck libcap
build_inst_pck libxcrypt
build_inst_pck shadow
build_inst_pck gcc
build_inst_pck ncurses
build_inst_pck sed
build_inst_pck psmisc
build_inst_pck gettext
build_inst_pck bison
build_inst_pck grep
build_inst_pck bash
build_inst_pck libtool
build_inst_pck gdbm
build_inst_pck gperf
build_inst_pck expat
build_inst_pck inetutils
build_inst_pck less
build_inst_pck perl
build_inst_pck xml-parser
build_inst_pck intltool
build_inst_pck autoconf
build_inst_pck automake
build_inst_pck openssl
build_inst_pck elfutils
build_inst_pck libffi
build_inst_pck python
build_inst_pck flit_core
build_inst_pck wheel
build_inst_pck setuptools
build_inst_pck ninja
build_inst_pck meson
build_inst_pck kmod
build_inst_pck coreutils
build_inst_pck check
build_inst_pck diffutils
build_inst_pck gawk
build_inst_pck findutils
build_inst_pck groff
build_inst_pck grub
build_inst_pck gzip
build_inst_pck iproute2
build_inst_pck kbd
build_inst_pck libpipeline
build_inst_pck make
build_inst_pck patch
build_inst_pck tar
build_inst_pck texinfo
build_inst_pck vim
build_inst_pck markupsafe
build_inst_pck jinja2
build_inst_pck systemd
build_inst_pck dbus
build_inst_pck man-db
build_inst_pck procps-ng
build_inst_pck util-linux
build_inst_pck e2fsprogs

do_install_process cleanup_files
do_install_process do_init_config

build_inst_pck linux

do_install_process finish_initial_config

build_inst_pck bash-startup

build_inst_pck libunistring
build_inst_pck libidn2
build_inst_pck libpsl
build_inst_pck libtasn1
build_inst_pck p11-kit
build_inst_pck make-ca
build_inst_pck wget
build_inst_pck linux-pam
build_inst_pck shadow-pam
build_inst_pck systemd-pam

plx_umount_virt
