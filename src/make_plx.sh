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
    if [ ! -l $PLX/etc/systemd/network/99-default.link ]; then
	    sudo ln -s /dev/null $PLX/etc/systemd/network/99-default.link
    fi

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

    sudo tee $PLX/etc/resolv.conf > /dev/null << "EOF"
nameserver 8.8.8.8

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
    set -e
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
build_inst_pck sudo
build_inst_pck openssh

build_inst_pck icu
build_inst_pck libxml2
build_inst_pck docbook-xsl-nons
build_inst_pck docbook-xml
build_inst_pck libxslt
build_inst_pck duktape
build_inst_pck pcre2
build_inst_pck docutils
build_inst_pck glib
build_inst_pck polkit

build_inst_pck curl
build_inst_pck libarchive
build_inst_pck libuv
build_inst_pck nghttp2
build_inst_pck cmake
build_inst_pck llvm

build_inst_pck sqlite
build_inst_pck libssh2
build_inst_pck python-sqlite
build_inst_pck rustc
build_inst_pck rust-bindgen
build_inst_pck cbindgen
build_inst_pck cargo-c
build_inst_pck graphviz
build_inst_pck vala
build_inst_pck nettle
build_inst_pck gnutls
build_inst_pck libgpg-error
build_inst_pck libassuan
build_inst_pck libgcrypt
build_inst_pck libksba
build_inst_pck npth
build_inst_pck lmdb
build_inst_pck krb5
build_inst_pck cyrus-sasl
build_inst_pck openldap
build_inst_pck pinentry
build_inst_pck gnupg
build_inst_pck which
build_inst_pck lua
build_inst_pck yasm
build_inst_pck nasm
build_inst_pck git
build_inst_pck six
build_inst_pck gdb
build_inst_pck c-ares
build_inst_pck brotli
build_inst_pck node

build_inst_pck graphite2
build_inst_pck libpng
build_inst_pck freetype-nohb
build_inst_pck harfbuzz
build_inst_pck freetype
build_inst_pck fontconfig
build_inst_pck fribidi
build_inst_pck xmlto
build_inst_pck giflib
build_inst_pck libjpeg-turbo
build_inst_pck jasper
build_inst_pck tiff
build_inst_pck lcms2
build_inst_pck libexif
build_inst_pck libmng
build_inst_pck libraw
build_inst_pck openjpeg
build_inst_pck pixman
build_inst_pck potrace
build_inst_pck libsass
build_inst_pck sassc
build_inst_pck libogg
build_inst_pck alsa-lib
build_inst_pck flac
build_inst_pck libaom
build_inst_pck libass
build_inst_pck libcddb
build_inst_pck neon
build_inst_pck libmusicbrainz
build_inst_pck opus
build_inst_pck libvorbis
build_inst_pck lame
build_inst_pck mpg123
build_inst_pck speex
build_inst_pck speexdsp
build_inst_pck libsndfile
build_inst_pck libvpx
build_inst_pck x264
build_inst_pck x265
build_inst_pck xorg-config

build_inst_pck util-macros
build_inst_pck xorgproto
build_inst_pck libXau
build_inst_pck libXdmcp
build_inst_pck xcb-proto
build_inst_pck libxcb
build_inst_pck xorg-libs

build_inst_pck libxcvt
build_inst_pck xcb-util
build_inst_pck xcb-util-image
build_inst_pck xcb-util-keysyms
build_inst_pck xcb-util-renderutil
build_inst_pck xcb-util-wm
build_inst_pck xcb-util-cursor
build_inst_pck wayland
build_inst_pck wayland-protocols
build_inst_pck vulkan-headers
build_inst_pck vulkan-loader
build_inst_pck libvdpau
build_inst_pck libdrm
build_inst_pck spriv-headers
build_inst_pck spriv-tools
build_inst_pck glslang
build_inst_pck yaml
build_inst_pck cython
build_inst_pck pyyaml
build_inst_pck mako
build_inst_pck libva-nomesa
build_inst_pck spriv-llvm-translator
build_inst_pck libclc
build_inst_pck ply
build_inst_pck mesa
build_inst_pck libva
build_inst_pck xbitmaps
build_inst_pck xorg-apps

build_inst_pck luit
build_inst_pck xcursor-themes
build_inst_pck xorg-fonts
build_inst_pck xkeyboard-config
build_inst_pck libtirpc
build_inst_pck libepoxy
build_inst_pck xwayland
build_inst_pck xorg-server
build_inst_pck libevdev
build_inst_pck mtdev
build_inst_pck xf86-input-evdev
build_inst_pck libinput
build_inst_pck xf86-input-libinput
build_inst_pck twm
build_inst_pck dejavu-fonts-ttf
build_inst_pck xterm
build_inst_pck xclock
build_inst_pck xinit

plx_umount_virt
