
autoreconf -fiv                                  
LINKS="/usr/bin/links" ./configure --prefix=/usr

make

make DESTDIR=$PCKDIR install

