
PYTHON=python3 ./configure $XORG_CONFIG

make

make DESTDIR=$PCKDIR install

