
mkdir -p $PCKDIR/etc
mkdir -p $PCKDIR/etc/ld.so.conf.d

patch -Np1 -i $PCKBASE/files/glibc-2.41-fhs-1.patch

mkdir build
cd build

echo "rootsbindir=/usr/sbin" > configparms

../configure --prefix=/usr                            \
             --disable-werror                         \
             --enable-kernel=5.4                      \
             --enable-stack-protector=strong          \
             --disable-nscd                           \
             libc_cv_slibdir=/usr/lib

make
touch $PCKDIR/etc/ld.so.conf

sed '/test-installation/s@$(PERL)@echo not running@' -i ../Makefile

make DESTDIR=$PCKDIR install

sed '/RTLDLIST=/s@/usr@@g' -i $PCKDIR/usr/bin/ldd

