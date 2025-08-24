mkdir __build && cd __build
meson setup --prefix=/usr            \
            --buildtype=release      \
            --wrap-mode=nofallback   \
            -D introspection=enabled \
            ..    
ninja
DESTDIR=$PCKDIR ninja install
