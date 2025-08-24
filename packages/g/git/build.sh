
./configure --prefix=/usr  \
            --with-gitconfig=/etc/gitconfig \
            --with-python=python3

make

make perllibdir=/usr/lib/perl5/5.40/site_perl DESTDIR=$PCKDIR install
