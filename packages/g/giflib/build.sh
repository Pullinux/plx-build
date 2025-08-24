patch -Np1 -i $PCKBASE/files/giflib-5.2.2-upstream_fixes-1.patch

cp pic/gifgrid.gif doc/giflib-logo.gif

make

make PREFIX=/usr DESTDIR=$PCKDIR install

rm -fv $PCKDIR/usr/lib/libgif.a

