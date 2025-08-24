mkdir __build && cd __build
meson setup ..               \
      --prefix=/usr          \
      --buildtype=release    \
      --wrap-mode=nodownload
ninja
DESTDIR=$PCKDIR ninja install
