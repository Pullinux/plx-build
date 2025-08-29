patch -Np1 -i $PCKBASE/files/xine-lib-1.2.13-upstream_fixes-1.patch

./configure --prefix=/usr          \
            --disable-vcd          \
            --with-external-dvdnav \
            --docdir=/usr/share/doc/xine-lib-1.2.13
make

make DESTDIR=$PCKDIR install

