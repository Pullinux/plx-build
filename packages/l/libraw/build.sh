
./configure --prefix=/usr     \
            --enable-jpeg    \
            --enable-jasper  \
            --enable-lcms    \
            --disable-static \
            --docdir=/usr/share/doc/libraw-0.21.3

make

make DESTDIR=$PCKDIR install

