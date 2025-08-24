

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/speexdsp-1.2.1

make

make DESTDIR=$PCKDIR install

