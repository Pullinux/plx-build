
mkdir -v __build 
cd       __build 

cmake -D CMAKE_INSTALL_PREFIX=/usr \
      -D CMAKE_BUILD_TYPE=Release -W no-dev \
      ..  

make

make DESTDIR=$PCKDIR install

