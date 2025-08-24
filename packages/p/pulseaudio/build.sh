mkdir __build && cd __build

meson setup --prefix=/usr       \
            --buildtype=release \
            -D database=gdbm    \
            -D doxygen=false    \
            -D bluez5=disabled  \
            ..    
ninja
DESTDIR=$PCKDIR ninja install

rm $PCKDIR/usr/share/dbus-1/system.d/pulseaudio-system.conf
