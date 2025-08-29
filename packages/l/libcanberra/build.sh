patch -Np1 -i $PCKBASE/files/libcanberra-0.30-wayland-1.patch

./configure --prefix=/usr --disable-oss

make

make docdir=/usr/share/doc/libcanberra-0.30 DESTDIR=$PCKDIR install

