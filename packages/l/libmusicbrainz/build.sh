
patch -Np1 -i $PCKBASE/files/libmusicbrainz-5.1.0-cmake_fixes-1.patch

sed -e 's/xmlErrorPtr /const xmlError */'     \
    -i src/xmlParser.cc

mkdir build &&
cd    build &&

cmake -D CMAKE_INSTALL_PREFIX=/usr -D CMAKE_BUILD_TYPE=Release ..

make

make DESTDIR=$PCKDIR install

