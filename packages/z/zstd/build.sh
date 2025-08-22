make prefix=/usr
make prefix=/usr DESTDIR=$PCKDIR install
rm -v $PCKDIR/usr/lib/libzstd.a
