
./configure --prefix=/usr 

make

make DESTDIR=$PCKDIR install

rm -v $PCKDIR/usr/lib/libSDL2*.a
