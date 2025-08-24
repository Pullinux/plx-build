
./configure --prefix=/usr           \
            --disable-docker-tests \
            --disable-static

make

make DESTDIR=$PCKDIR install

