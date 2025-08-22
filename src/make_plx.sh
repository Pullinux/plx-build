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

plx_umount_virt
