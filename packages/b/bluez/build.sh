
./configure --prefix=/usr          \
            --sysconfdir=/etc     \
            --localstatedir=/var  \
            --disable-manpages    \
            --enable-library 

make

make DESTDIR=$PCKDIR install

mkdir -p $PCKDIR/usr/sbin

ln -svf ../libexec/bluetooth/bluetoothd $PCKDIR/usr/sbin

install -v -dm755 $PCKDIR/etc/bluetooth 
install -v -m644 src/main.conf $PCKDIR/etc/bluetooth/main.conf
