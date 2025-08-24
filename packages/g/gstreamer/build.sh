mkdir __build && cd __build
meson setup ..            \
      --prefix=/usr       \
      --buildtype=release \
      -D gst_debug=false
ninja
DESTDIR=$PCKDIR ninja install
