
./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            --enable-shared         \
            --disable-static        \
            CFLAGS="${CFLAGS:--g -O3} -fPIC" 

make

make DESTDIR=$PCKDIR install

mkdir -p $PCKDIR/usr/include/a52dec

cp liba52/a52_internal.h $PCKDIR/usr/include/a52dec &&
install -v -m644 -D doc/liba52.txt \
    /usr/share/doc/liba52-0.8.0/liba52.txt

