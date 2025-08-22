./configure --prefix=/usr \
            --docdir=/usr/share/doc/flex-2.6.4 \
            --disable-static
make
make DESTDIR=$PCKDIR install

ln -sv flex   $PCKDIR/usr/bin/lex
ln -sv flex.1 $PCKDIR/usr/share/man/man1/lex.1
