
./configure --prefix=/usr 

make

sed -i '/INSTALL_DATA.*libpcap.a\|RANLIB.*libpcap.a/ s/^/#/' Makefile

make DESTDIR=$PCKDIR install

