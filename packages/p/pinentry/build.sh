sed -i "/FLTK 1/s/3/4/" configure   
sed -i '14462 s/1.3/1.4/' configure

./configure --prefix=/usr --enable-pinentry-tty

make

make DESTDIR=$PCKDIR install

