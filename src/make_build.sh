#!/bin/bash
set -Eeuo pipefail

source .config

: ${PLX_DEV:?"PLX Device Not Set"}
: ${PLX:?"PLX Path Not Set"}

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source $SRC_DIR/common.sh

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

run_step plx_format
run_step plx_mount
run_step plx_init
run_step plx_create_paths
run_step plx_user_setup
run_step build_cross_binutils_p1
run_step build_cross_gcc_p1
run_step build_cross_linux_headers
run_step build_cross_glibc
run_step build_cross_libstdcpp
run_step build_cross_m4
run_step build_cross_ncurses
run_step build_cross_bash
run_step build_cross_coreutils
run_step build_cross_diffutils
run_step build_cross_file
run_step build_cross_findutils

