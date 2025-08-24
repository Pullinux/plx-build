mkdir __build && cd __build
meson setup ..                  \
      --prefix=$XORG_PREFIX     \
      --buildtype=release       \
      -D debug-gui=false        \
      -D tests=false            \
      -D libwacom=false         \
      -D udev-dir=/usr/lib/udev
ninja
DESTDIR=$PCKDIR ninja install
