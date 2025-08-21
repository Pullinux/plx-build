#!/bin/bash
set -Eeuo pipefail

source .config

: ${PLX_DEV:?"PLX Device Not Set"}
: ${PLX:?"PLX Path Not Set"}

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source $SRC_DIR/common.sh
source $SRC_DIR/plx_common.sh

sudo cp $SRC_DIR/plx_common.sh $PLX/usr/share/plx/tmp/

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

build_package man-pages-6.12.tar.xz build_pck_manpages

