
patch -Np1 -i $PCKBASE/files/bzip2-1.0.8-install_docs-1.patch


sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile

make -f Makefile-libbz2_so
make clean

make
make PREFIX=$PCKDIR/usr install

mkdir -p $PCKDIR/usr/lib/
mkdir -p $PCKDIR/usr/bin/

cp -av libbz2.so.* $PCKDIR/usr/lib
ln -sv libbz2.so.1.0.8 $PCKDIR/usr/lib/libbz2.so

cp -v bzip2-shared $PCKDIR/usr/bin/bzip2
for i in $PCKDIR/usr/bin/{bzcat,bunzip2}; do
  ln -sfv bzip2 $i
done

rm -fv $PCKDIR/usr/lib/libbz2.a
