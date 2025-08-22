./configure --prefix=/usr    \
            --disable-static \
            --enable-libgdbm-compat
make
make DESTDIR=$PCKDIR install
