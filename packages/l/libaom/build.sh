mkdir aom-build &&
cd    aom-build &&

cmake -D CMAKE_INSTALL_PREFIX=/usr \
      -D CMAKE_BUILD_TYPE=Release  \
      -D BUILD_SHARED_LIBS=1       \
      -D ENABLE_DOCS=no            \
      -G Ninja ..
ninja
DESTDIR=$PCKDIR ninja install
rm -v $PCKDIR/usr/lib/libaom.a