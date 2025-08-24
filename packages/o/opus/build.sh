mkdir __build && cd __build
meson setup --prefix=/usr        \
            --buildtype=release  \
            -D docdir=/usr/share/doc/opus-1.5.2 
ninja
DESTDIR=$PCKDIR ninja install
