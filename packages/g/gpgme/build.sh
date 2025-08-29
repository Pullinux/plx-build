
mkdir build 
cd    build 

../configure --prefix=/usr --disable-gpg-test 
make PYTHONS=

make DESTDIR=$PCKDIR install PYTHONS=

