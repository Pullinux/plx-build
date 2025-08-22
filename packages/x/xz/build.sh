
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/xz-5.6.4

make
make DESTDIR=$PCKDIR install

