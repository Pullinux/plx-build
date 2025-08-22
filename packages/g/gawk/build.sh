sed -i 's/extras//' Makefile.in

./configure --prefix=/usr
make

make DESTDIR=$PCKDIR install

ln -sv gawk.1 $PCKDIR/usr/share/man/man1/awk.1
