
mkdir -v __build 
cd       __build 

SKIP_OPTIONAL='Discount;DjVuLibre;EPub;LibSpectre;LibZip'

cmake -D CMAKE_INSTALL_PREFIX=$KF6_PREFIX \
      -D CMAKE_BUILD_TYPE=Release         \
      -D BUILD_TESTING=OFF                \
      -D FORCE_NOT_REQUIRED_DEPENDENCIES="$SKIP_OPTIONAL" \
      -W no-dev ..

make

make DESTDIR=$PCKDIR install

