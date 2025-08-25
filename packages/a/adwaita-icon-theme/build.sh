mkdir __build && cd __build
meson setup --prefix=/usr ..
ninja
DESTDIR=$PCKDIR ninja install
