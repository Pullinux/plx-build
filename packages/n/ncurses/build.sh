./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            --with-shared           \
            --without-debug         \
            --without-normal        \
            --with-cxx-shared       \
            --enable-pc-files       \
            --with-pkg-config-libdir=/usr/lib/pkgconfig
make
make DESTDIR=$PCKDIR install

make DESTDIR=$PWD/dest install
mkdir -p $PCKDIR/usr/lib/pkgconfig

install -vm755 dest/usr/lib/libncursesw.so.6.5 $PCKDIR/usr/lib
rm -v  dest/usr/lib/libncursesw.so.6.5
sed -e 's/^#if.*XOPEN.*$/#if 1/' \
    -i dest/usr/include/curses.h
cp -av dest/* $PCKDIR/

for lib in ncurses form panel menu ; do
    ln -sfv lib${lib}w.so $PCKDIR/usr/lib/lib${lib}.so
    ln -sfv ${lib}w.pc    $PCKDIR/usr/lib/pkgconfig/${lib}.pc
done

ln -sfv libncursesw.so $PCKDIR/usr/lib/libcurses.so
