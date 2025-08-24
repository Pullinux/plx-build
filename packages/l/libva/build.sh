
cd build 

meson setup --prefix=$XORG_PREFIX --buildtype=release 
ninja
DESTDIR=$PCKDIR ninja install

