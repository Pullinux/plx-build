sed -i 's/def HAVE_TERMCAP_TGETENT/ 1/' telnet/telnet.c

./configure --prefix=/usr        \
            --bindir=/usr/bin    \
            --localstatedir=/var \
            --disable-logger     \
            --disable-whois      \
            --disable-rcp        \
            --disable-rexec      \
            --disable-rlogin     \
            --disable-rsh        \
            --disable-servers
make
make DESTDIR=$PCKDIR install

mkdir -p $PCKDIR/usr/bin
mkdir -p $PCKDIR/usr/sbin

mv -v $PCKDIR/usr/{,s}bin/ifconfig
