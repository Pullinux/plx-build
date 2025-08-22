./configure --prefix=/usr
make
make html
make DESTDIR=$PCKDIR install
install -d -m755           $PCKDIR/usr/share/doc/sed-4.9
install -m644 doc/sed.html $PCKDIR/usr/share/doc/sed-4.9
