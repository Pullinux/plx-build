mkdir __build && cd __build
meson setup --prefix=/usr --buildtype=release -D system-lua=true ..
ninja
DESTDIR=$PCKDIR ninja install

mv -v $PCKDIR/usr/share/doc/wireplumber{,-0.5.8}
