./configure --prefix=/usr --disable-static
make
make DESTDIR=$PCKDIR install
ln -sfv bsdunzip $PCKDIR/usr/bin/unzip
