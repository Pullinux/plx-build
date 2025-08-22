
make DESTDIR=$PCKDIR install
install -vdm755 $PCKDIR/etc/ssl/local

$PCKDIR/usr/sbin/make-ca -g -D $PCKDIR/

