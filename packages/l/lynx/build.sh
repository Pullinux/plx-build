
./configure --prefix=/usr           \
            --sysconfdir=/etc/lynx  \
            --with-zlib             \
            --with-bzlib            \
            --with-ssl              \
            --with-screen=ncursesw  \
            --enable-locale-charset \
            --datadir=/usr/share/doc/lynx-2.9.2 

make

make DESTDIR=$PCKDIR install

