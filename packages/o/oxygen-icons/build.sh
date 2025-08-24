sed -i '/( oxygen/ s/)/scalable )/' CMakeLists.txt

mkdir -v __build 
cd       __build 

cmake -D CMAKE_INSTALL_PREFIX=/usr -W no-dev ..

make

make DESTDIR=$PCKDIR install

