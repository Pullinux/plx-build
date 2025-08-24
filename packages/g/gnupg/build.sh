
mkdir build 
cd    build 

../configure --prefix=/usr           \
             --localstatedir=/var    \
             --sysconfdir=/etc       \
             --docdir=/usr/share/doc/gnupg-2.4.7 

make

make DESTDIR=$PCKDIR install

