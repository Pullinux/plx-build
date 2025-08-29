
mkdir -v __build 
cd       __build 


cmake -D CMAKE_INSTALL_PREFIX=$KF6_PREFIX \
      -D CMAKE_BUILD_TYPE=Release         \
      -D BUILD_WITH_QT6=ON                \
      -D BUILD_TESTING=OFF                \
      -W no-dev ..

make

make DESTDIR=$PCKDIR install

