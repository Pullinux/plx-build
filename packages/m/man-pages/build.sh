rm -v man3/crypt*
make -R GIT=false DESTDIR=$PCKDIR prefix=/usr install
