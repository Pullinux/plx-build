mkdir __build && cd __build
meson setup                \
      --prefix=/usr        \
      --buildtype=release  \
      -D gtk_doc=false     \
      -D tests=false       \
      .. 
ninja
DESTDIR=$PCKDIR ninja install
