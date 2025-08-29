mkdir __build && cd __build
cmake -D CMAKE_BUILD_TYPE=Release   \
      -D CMAKE_INSTALL_PREFIX=/usr  \
      -D TESTDATADIR=$PWD/testfiles \
      -D ENABLE_QT5=OFF             \
      -D ENABLE_UNSTABLE_API_ABI_HEADERS=ON \
      -G Ninja .. 
ninja
DESTDIR=$PCKDIR ninja install

tar -xf $PCKBASE/files/poppler-data-0.4.12.tar.gz &&
cd poppler-data-0.4.12
make prefix=$PCKBASE/usr install
