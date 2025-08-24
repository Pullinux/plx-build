
./configure --prefix=/usr                                    \
            --sysconfdir=/etc                               \
            --disable-static                                \
            --disable-gssapi 

make

make DESTDIR=$PCKDIR install

