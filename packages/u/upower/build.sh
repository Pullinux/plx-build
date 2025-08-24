mkdir __build && cd __build
meson setup ..            \
      --prefix=/usr       \
      --buildtype=release \
      -D gtk-doc=false    \
      -D man=false 
ninja
DESTDIR=$PCKDIR ninja install
