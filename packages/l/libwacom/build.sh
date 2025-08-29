mkdir __build && cd __build
meson setup ..            \
      --prefix=/usr       \
      --buildtype=release \
      -D tests=disabled
ninja
DESTDIR=$PCKDIR ninja install
