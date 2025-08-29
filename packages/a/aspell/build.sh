
./configure --prefix=/usr 

make

make DESTDIR=$PCKDIR install

mkdir -p $PCKDIR/usr/lib/
ln -svfn aspell-0.60 $PCKDIR/usr/lib/aspell 

install -v -m755 -d $PCKDIR/usr/share/doc/aspell-0.60.8.1/aspell{,-dev}.html 

install -v -m644 manual/aspell.html/* \
    $PCKDIR/usr/share/doc/aspell-0.60.8.1/aspell.html 

install -v -m644 manual/aspell-dev.html/* \
    $PCKDIR/usr/share/doc/aspell-0.60.8.1/aspell-dev.html

mkdir -p $PCKDIR/usr/bin

install -v -m 755 scripts/ispell $PCKDIR/usr/bin/
install -v -m 755 scripts/spell $PCKDIR/usr/bin/

