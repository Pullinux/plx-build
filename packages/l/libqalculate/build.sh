
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/libqalculate-5.5.1
make

make DESTDIR=$PCKDIR install

rm -v $PCKDIR/usr/lib/libqalculate.la
