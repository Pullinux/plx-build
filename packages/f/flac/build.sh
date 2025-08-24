
./configure --prefix=/usr                                \
            --disable-thorough-tests                     \
            --docdir=/usr/share/doc/flac-1.5.0

make

make DESTDIR=$PCKDIR install

