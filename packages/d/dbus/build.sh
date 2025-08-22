mkdir build
cd    build

meson setup --prefix=/usr --buildtype=release --wrap-mode=nofallback ..
ninja
DESTDIR=$PCKDIR ninja install

mkdir -p $PCKDIR/var/lib/dbus
ln -sfv /etc/machine-id $PCKDIR/var/lib/dbus
