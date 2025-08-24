
CXX="/usr/bin/g++"               \
./configure --prefix=/usr        \
            --enable-shared      \
            --with-system-expat  \
            --enable-optimizations

make

make DESTDIR=$PCKDIR install

