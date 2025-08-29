
./configure --prefix=/usr      \
            --disable-nftables \
            --enable-libipq

make

make DESTDIR=$PCKDIR install

