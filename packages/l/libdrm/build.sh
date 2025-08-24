mkdir __build && cd __build
meson setup --prefix=$XORG_PREFIX \
            --buildtype=release   \
            -D udev=true          \
            -D valgrind=disabled  \
            ..          
ninja
DESTDIR=$PCKDIR ninja install
