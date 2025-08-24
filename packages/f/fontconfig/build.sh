
./configure --prefix=/usr         \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --disable-docs       \
            --docdir=/usr/share/doc/fontconfig-2.16.0

make

make DESTDIR=$PCKDIR install

