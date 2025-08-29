
mkdir -v __build 
cd       __build 

cmake -D CMAKE_INSTALL_PREFIX=/usr \
      -D CMAKE_BUILD_TYPE=Release  \
      -D KDSoap_QT6=ON             \
      -D CMAKE_INSTALL_DOCDIR=/usr/share/doc/kdsoap-2.2.0 \
      .. 
make

make DESTDIR=$PCKDIR install

