
patch -Np1 -i $PCKBASE/files/cairo-1.18.2-upstream_fixes-1.patch

mkdir __build && cd __build
meson setup --prefix=/usr --buildtype=release ..
ninja
DESTDIR=$PCKDIR ninja install
