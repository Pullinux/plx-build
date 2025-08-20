
build_cross_destdir() {
	make
	make DESTDIR=$PLX install
}

build_cross_binutils_p1() {
    init_module binutils
    pushd modules/binutils

    mkdir -v build
    cd       build

    ../configure --prefix=$PLX/tools \
             --with-sysroot=$PLX \
             --target=$PLX_TGT   \
             --disable-nls       \
             --enable-gprofng=no \
             --disable-werror    \
             --enable-new-dtags  \
             --enable-default-hash-style=gnu
    make
    make install
    cd ..
    popd
}

build_cross_gcc_p1() {

    init_module gcc
    pushd modules/gcc

    sed -e '/m64=/s/lib64/lib/' -i.orig gcc/config/i386/t-linux64

    tar -xf ../mpfr-4.2.1.tar.xz
    mv -v mpfr-4.2.1 mpfr
    tar -xf ../gmp-6.3.0.tar.xz
    mv -v gmp-6.3.0 gmp
    tar -xf ../mpc-1.3.1.tar.gz
    mv -v mpc-1.3.1 mpc


    mkdir -v build
    cd       build

    ../configure                  \
        --target=$PLX_TGT         \
        --prefix=$PLX/tools       \
        --with-glibc-version=2.41 \
        --with-sysroot=$PLX       \
        --with-newlib             \
        --without-headers         \
        --enable-default-pie      \
        --enable-default-ssp      \
        --disable-nls             \
        --disable-shared          \
        --disable-multilib        \
        --disable-threads         \
        --disable-libatomic       \
        --disable-libgomp         \
        --disable-libquadmath     \
        --disable-libssp          \
        --disable-libvtv          \
        --disable-libstdcxx       \
        --enable-languages=c,c++

    make
    make install

    cd ..
    cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
        `dirname $($PLX_TGT-gcc -print-libgcc-file-name)`/include/limits.h

    popd
}

build_cross_linux_headers() {
	init_module linux

	pushd modules/linux

	make mrproper

	make headers
	find usr/include -type f ! -name '*.h' -delete
	cp -rv usr/include $PLX/usr

	popd
}

build_cross_glibc() {
	init_module glibc
	pushd modules/glibc

	ln -sfv ../lib/ld-linux-x86-64.so.2 $PLX/lib64/
        ln -sfv ../lib/ld-linux-x86-64.so.2 $PLX/lib64/ld-lsb-x86-64.so.3

	mkdir build
	cd build

	echo "rootsbindir=/usr/sbin" > configparms

	../configure                             \
      		--prefix=/usr                      \
      		--host=$PLX_TGT                    \
      		--build=$(../scripts/config.guess) \
      		--enable-kernel=5.4                \
      		--with-headers=$PLX/usr/include    \
      		--disable-nscd                     \
      		libc_cv_slibdir=/usr/lib

	make
	make DESTDIR=$PLX install

	sed '/RTLDLIST=/s@/usr@@g' -i $PLX/usr/bin/ldd

	popd

	deinit_module glibc
}

build_cross_libstdcpp() {
	init_module gcc
	pushd modules/gcc

	rm -rf build
	mkdir build
	cd build

	../libstdc++-v3/configure           \
    		--host=$PLX_TGT                 \
    		--build=$(../config.guess)      \
    		--prefix=/usr                   \
    		--disable-multilib              \
    		--disable-nls                   \
    		--disable-libstdcxx-pch         \
    		--with-gxx-include-dir=/tools/$PLX_TGT/include/c++/14.2.0

	build_cross_destdir
	rm -v $PLX/usr/lib/lib{stdc++{,exp,fs},supc++}.la

	popd
}

build_cross_m4() {
	init_module m4
	pushd modules/m4

	autoreconf --force
	./configure --prefix=/usr   \
            --host=$PLX_TGT \
            --build=$(build-aux/config.guess)

	echo "MAKING WITHOUT HELP2MAN"

	sed 's/^HELP2MAN/HELP2MAN=echo #/' -i doc/Makefile
	make
	make DESTDIR=$PLX install

	popd

	deinit_module m4
}

build_cross_ncurses() {
	init_module ncurses
	pushd modules/ncurses

	mkdir build
	pushd build
	  ../configure AWK=gawk
	  make -C include
	  make -C progs tic
	popd

	./configure --prefix=/usr                \
            --host=$PLX_TGT              \
            --build=$(./config.guess)    \
            --mandir=/usr/share/man      \
            --with-manpage-format=normal \
            --with-shared                \
            --without-normal             \
            --with-cxx-shared            \
            --without-debug              \
            --without-ada                \
            --disable-stripping          \
            AWK=gawk

	make
	make DESTDIR=$PLX TIC_PATH=$(pwd)/build/progs/tic install
	ln -sv libncursesw.so $PLX/usr/lib/libncurses.so
	
	sed -e 's/^#if.*XOPEN.*$/#if 1/' \
	    -i $PLX/usr/include/curses.h

	popd

	deinit_module ncurses
}

build_cross_bash() {
	init_module bash
	pushd modules/bash

	./configure --prefix=/usr                      \
            --build=$(sh support/config.guess) \
            --host=$PLX_TGT                    \
            --without-bash-malloc

	build_cross_destdir

	ln -sv bash $PLX/bin/sh

	popd

	deinit_module bash
}

build_cross_coreutils() {
	init_module coreutils
	pushd modules/coreutils

	autoreconf --force
	./configure --prefix=/usr                     \
            --host=$PLX_TGT                   \
            --build=$(build-aux/config.guess) \
            --enable-install-program=hostname \
            --enable-no-install-program=kill,uptime

	build_cross_destdir

	mv -v $PLX/usr/bin/chroot              $PLX/usr/sbin
	mkdir -pv $PLX/usr/share/man/man8
	mv -v $PLX/usr/share/man/man1/chroot.1 $PLX/usr/share/man/man8/chroot.8
	sed -i 's/"1"/"8"/'                    $PLX/usr/share/man/man8/chroot.8

	popd

	deinit_module coreutils
}

build_cross_diffutils() {
	init_module diffutils
	pushd modules/diffutils

	./configure --prefix=/usr   \
            --host=$PLX_TGT \
            --build=$(./build-aux/config.guess)

	build_cross_destdir

	popd
	deinit_module diffutils
}

build_cross_file() {
	init_module file
	pushd modules/file

	autoreconf --force

	mkdir build
	pushd build
	  ../configure --disable-bzlib      \
	               --disable-libseccomp \
	               --disable-xzlib      \
	               --disable-zlib
	  make
	popd

	echo "CONFIGURE"
	./configure --prefix=/usr --host=$PLX_TGT --build=$(./config.guess)

	echo "MAKE"
	make FILE_COMPILE=$(pwd)/build/src/file

	make DESTDIR=$PLX install

	rm -v $PLX/usr/lib/libmagic.la

	popd
	deinit_module file
}

build_cross_findutils() {
	init_module findutils
	pushd modules/findutils

	autoreconf --force
	./configure --prefix=/usr                   \
            --localstatedir=/var/lib/locate \
            --host=$PLX_TGT                 \
            --build=$(build-aux/config.guess)

	build_cross_destdir

	popd
	deinit_module findutils
}

