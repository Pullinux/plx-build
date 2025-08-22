./configure --prefix=/usr --sysconfdir=/etc
make
make DESTDIR=$PCKDIR install
