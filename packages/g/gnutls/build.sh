
./configure --prefix=/usr  \
            --docdir=/usr/share/doc/gnutls-3.8.9 \
            --with-default-trust-store-pkcs11="pkcs11:"

make

make DESTDIR=$PCKDIR install

