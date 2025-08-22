./config --prefix=/usr         \
         --openssldir=/etc/ssl \
         --libdir=lib          \
         shared                \
         zlib-dynamic
make

sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile
make DESTDIR=$PCKDIR MANSUFFIX=ssl install

mv -v $PCKDIR/usr/share/doc/openssl $PCKDIR/usr/share/doc/openssl-3.4.1
