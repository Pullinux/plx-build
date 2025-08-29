
PYTHON=python3 ./configure --prefix=/usr --disable-static

make

make DESTDIR=$PCKDIR install

