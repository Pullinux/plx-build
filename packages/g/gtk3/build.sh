mkdir __build && cd __build
meson setup ..                 \
      --prefix=/usr            \
      --buildtype=release      \
      -D man=true              \
      -D broadway_backend=true
ninja
DESTDIR=$PCKDIR ninja install
