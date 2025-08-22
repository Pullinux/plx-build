./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/libunistring-1.3
make
make DESTDIR=$PCKDIR install
