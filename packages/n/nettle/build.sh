
./configure --prefix=/usr  --disable-static 

make

make DESTDIR=$PCKDIR install

chmod   -v   755 $PCKDIR/usr/lib/lib{hogweed,nettle}.so 
