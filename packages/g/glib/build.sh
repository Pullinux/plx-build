
patch -Np1 -i $PCKBASE/files/glib-skip_warnings-1.patch

mkdir __build && cd __build
meson setup ..                  \
      --prefix=/usr             \
      --buildtype=release       \
      -D introspection=disabled \
      -D glib_debug=disabled    \
      -D man-pages=enabled      \
      -D sysprof=disabled       
ninja

DESTDIR=$PCKDIR ninja install

ninja install

tar xf $PCKBASE/files/gobject-introspection-1.82.0.tar.xz 

meson setup gobject-introspection-1.82.0 gi-build \
            --prefix=/usr --buildtype=release     
ninja -C gi-build

DESTDIR=$PCKDIR ninja -C gi-build install

ninja -C gi-build install

meson configure -D introspection=enabled &&
ninja
DESTDIR=$PCKDIR ninja install
