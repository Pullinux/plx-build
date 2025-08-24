autoreconf -fi
./configure --prefix=/usr 

make

make DESTDIR=$PCKDIR install

