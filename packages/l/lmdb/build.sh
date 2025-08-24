
cd libraries/liblmdb 
make                 
sed -i 's| liblmdb.a||' Makefile

make DESTDIR=$PCKDIR prefix=/usr install

