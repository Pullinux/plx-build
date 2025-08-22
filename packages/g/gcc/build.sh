
sed -e '/m64=/s/lib64/lib/' -i.orig gcc/config/i386/t-linux64

mkdir -v build
cd       build

../configure --prefix=/usr            \
             LD=ld                    \
             --enable-languages=c,c++ \
             --enable-default-pie     \
             --enable-default-ssp     \
             --enable-host-pie        \
             --disable-multilib       \
             --disable-bootstrap      \
             --disable-fixincludes    \
             --with-system-zlib

make
make DESTDIR=$PCKDIR install

chown -v -R root:root \
    $PCKDIR/usr/lib/gcc/x86_64-pc-linux-gnu/14.2.0/include{,-fixed}

mkdir -p $PCKDIR/usr/lib
ln -svr /usr/bin/cpp $PCKDIR/usr/lib

ln -sv gcc.1 $PCKDIR/usr/share/man/man1/cc.1

mkdir -p $PCKDIR/usr/lib/bfd-plugins/

ln -sfv ../../libexec/gcc/x86_64-pc-linux-gnu/14.2.0/liblto_plugin.so $PCKDIR/usr/lib/bfd-plugins/

mkdir -pv $PCKDIR/usr/share/gdb/auto-load/usr/lib
mv -v $PCKDIR/usr/lib/*gdb.py $PCKDIR/usr/share/gdb/auto-load/usr/lib
