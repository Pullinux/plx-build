mkdir __build && cd __build
meson setup --prefix=$XORG_PREFIX --buildtype=release 
ninja
DESTDIR=$PCKDIR ninja install
