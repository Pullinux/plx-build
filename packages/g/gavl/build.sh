sed -i "/stdio/a #include <string.h>" src/fill_test.c

LIBS=-lm                         \
./configure --prefix=/usr        \
            --without-doxygen    \
            --with-cpuflags=none \
            --docdir=/usr/share/doc/gavl-1.4.0

make

make DESTDIR=$PCKDIR install

