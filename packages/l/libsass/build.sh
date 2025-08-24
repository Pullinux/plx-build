
autoreconf -fi 

./configure --prefix=/usr --disable-static

make

make DESTDIR=$PCKDIR install

