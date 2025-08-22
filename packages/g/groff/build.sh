PAGE=letter ./configure --prefix=/usr
make
make DESTDIR=$PCKDIR install
