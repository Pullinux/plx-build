./configure --prefix=/usr      \
            --sysconfdir=/etc  \
            --with-ssl=openssl
make
make DESTDIR=$PCKDIR install
