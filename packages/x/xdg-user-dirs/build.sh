
./configure --prefix=/usr            \
            --sysconfdir=/etc       \
            --disable-documentation

make

make DESTDIR=$PCKDIR install

