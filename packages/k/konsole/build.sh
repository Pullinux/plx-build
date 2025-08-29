
patch -Np1 -i $PCKBASE/files/konsole-24.12.2-scrollbar-1.patch

mkdir -v __build 
cd       __build 

cmake -D CMAKE_INSTALL_PREFIX=$KF6_PREFIX \
      -D CMAKE_BUILD_TYPE=Release         \
      -D BUILD_TESTING=OFF                \
      -W no-dev ..

make

make DESTDIR=$PCKDIR install

