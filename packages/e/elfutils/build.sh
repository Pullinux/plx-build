./configure --prefix=/usr                \
            --disable-debuginfod         \
            --enable-libdebuginfod=dummy
make

make DESTDIR=$PCKDIR -C libelf install

mkdir -p $PCKDIR/usr/lib/pkgconfig

install -vm644 config/libelf.pc $PCKDIR/usr/lib/pkgconfig
rm $PCKDIR/usr/lib/libelf.a
