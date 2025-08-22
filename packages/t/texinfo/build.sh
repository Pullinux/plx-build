./configure --prefix=/usr
make
make DESTDIR=$PCKDIR install
make DESTDIR=$PCKDIR TEXMF=/usr/share/texmf install-tex
