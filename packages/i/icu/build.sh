cd source 
./configure --prefix=/usr
make
make DESTDIR=$PCKDIR install
