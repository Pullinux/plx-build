
mkdir build 
cd    build 

meson setup --prefix=/usr --buildtype=release .. 
ninja

DESTDIR=$PCKDIR ninja install

