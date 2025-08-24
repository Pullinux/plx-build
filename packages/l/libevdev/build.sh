mkdir __build && cd __build
meson setup ..                  \
      --prefix=$XORG_PREFIX     \
      --buildtype=release       \
      -D documentation=disabled
ninja
DESTDIR=$PCKDIR ninja install
