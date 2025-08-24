
patch -Np1 -i $PCKBASE/files/openldap-2.6.9-consolidated-1.patch 
autoconf 

./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --disable-static     \
            --enable-dynamic     \
            --disable-debug      \
            --disable-slapd 

make depend 

make

make DESTDIR=$PCKDIR install

