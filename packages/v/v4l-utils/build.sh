mkdir __build && cd __build

meson setup ..            \
      --prefix=/usr       \
      --buildtype=release \
      -D gconv=disabled   \
      -D doxygen-doc=disabled
ninja
DESTDIR=$PCKDIR ninja install

mkdir -p $PCKDIR/usr/bin

for prog in v4l2gl v4l2grab
do
   cp -v contrib/test/$prog $PCKDIR/usr/bin
done

