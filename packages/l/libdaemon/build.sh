
./configure --prefix=/usr --disable-static

make

make docdir=/usr/share/doc/libdaemon-0.14 DESTDIR=$PCKDIR install

