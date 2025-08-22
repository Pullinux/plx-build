
./configure --prefix=/usr
make
make DESTDIR=$PCKDIR install
rm -fv $PCKDIR/usr/lib/libz.a
