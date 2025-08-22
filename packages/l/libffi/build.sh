./configure --prefix=/usr          \
            --disable-static       \
            --with-gcc-arch=native
            
make
make DESTDIR=$PCKDIR install
