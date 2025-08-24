mkdir __build && cd __build
cmake -D CMAKE_INSTALL_PREFIX=/usr -G Ninja ..
ninja
DESTDIR=$PCKDIR ninja install
