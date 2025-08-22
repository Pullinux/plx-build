sed -i 's:\\\${:\\\$\\{:' intltool-update.in

./configure --prefix=/usr
make
make DESTDIR=$PCKDIR install
