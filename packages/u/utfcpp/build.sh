
mkdir -v __build 
cd       __build 

cmake -D CMAKE_INSTALL_PREFIX=/usr ..

make

make DESTDIR=$PCKDIR install

