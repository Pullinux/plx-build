sed -e '/TryExec/s|=|=/usr/bin/|' \
    -i xsession/lxqt.desktop.in
    
mkdir -v __build 
cd       __build 

cmake -D CMAKE_INSTALL_PREFIX=/usr \
      -D CMAKE_BUILD_TYPE=Release  \
      ..  

make

make DESTDIR=$PCKDIR install

