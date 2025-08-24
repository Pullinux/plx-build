
./configure --prefix=/usr --disable-static --disable-tester 

make

make DESTDIR=$PCKDIR install

