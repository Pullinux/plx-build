mkdir __build && cd __build
cmake -D CMAKE_INSTALL_PREFIX=/usr \
      -D CMAKE_BUILD_TYPE=Release  \
      -G Ninja ..  
ninja
DESTDIR=$PCKDIR ninja install
