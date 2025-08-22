
patch -Np1 -i $PCKBASE/files/expect-5.45.4-gcc14-1.patch

./configure --prefix=/usr           \
            --with-tcl=/usr/lib     \
            --enable-shared         \
            --disable-rpath         \
            --mandir=/usr/share/man \
            --with-tclinclude=/usr/include
make
make DESTDIR=$PCKDIR install

ln -svf expect5.45.4/libexpect5.45.4.so $PCKDIR/usr/lib
