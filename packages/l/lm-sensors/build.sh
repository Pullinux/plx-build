
make PREFIX=/usr           \
     BUILD_STATIC_LIB=0    \
     MANDIR=/usr/share/man \
     EXLDFLAGS=

make PREFIX=/usr        \
     DESTDIR=$PCKDIR BUILD_STATIC_LIB=0 \
     MANDIR=/usr/share/man install

