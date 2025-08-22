./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/expat-2.7.1
make
make DESTDIR=$PCKDIR install
