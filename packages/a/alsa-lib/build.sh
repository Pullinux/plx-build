
./configure 
make
make DESTDIR=$PCKDIR install

tar -C $PCKDIR/usr/share/alsa --strip-components=1 -xf $PCKBASE/files/alsa-ucm-conf-1.2.13.tar.bz2

