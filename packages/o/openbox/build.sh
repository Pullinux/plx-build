
autoreconf -fi 
./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  \
            --docdir=/usr/share/doc/openbox-3.6.1

make

make DESTDIR=$PCKDIR install

rm -v $PCKDIR/usr/share/xsessions/openbox-{gnome,kde}.desktop
