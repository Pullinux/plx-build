mkdir __build && cd __build
meson setup ..            \
      --prefix=/usr       \
      --buildtype=release \
      -D documentation=false
ninja
DESTDIR=$PCKDIR ninja install
