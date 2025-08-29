sh autogen.sh
./configure --prefix=/usr 

make

make DESTDIR=$PCKDIR install

