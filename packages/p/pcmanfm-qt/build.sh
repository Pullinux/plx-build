

mkdir -v __build 
cd       __build 

cmake -D CMAKE_INSTALL_PREFIX=/usr \
      -D CMAKE_BUILD_TYPE=Release  \
      ..  

make

make DESTDIR=$PCKDIR install

sed -e '/Categories=/s/=/=System;FileTools;/' \
    -e '/Name=/s/=.*/=File Manager PCManFM-Qt'/ \
    -i $PCKDIR/usr/share/applications/pcmanfm-qt.desktop
