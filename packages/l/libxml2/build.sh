./configure --prefix=/usr           \
            --sysconfdir=/etc       \
            --disable-static        \
            --with-history          \
            --with-icu              \
            PYTHON=/usr/bin/python3 \
            --docdir=/usr/share/doc/libxml2-2.13.6
make
make DESTDIR=$PCKDIR install

rm -vf $PCKDIR/usr/lib/libxml2.la
sed '/libs=/s/xml2.*/xml2"/' -i $PCKDIR/usr/bin/xml2-config
