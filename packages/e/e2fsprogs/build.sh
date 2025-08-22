mkdir -v build
cd       build

../configure --prefix=/usr           \
             --sysconfdir=/etc       \
             --enable-elf-shlibs     \
             --disable-libblkid      \
             --disable-libuuid       \
             --disable-uuidd         \
             --disable-fsck

make
make DESTDIR=$PCKDIR install

rm -fv $PCKDIR/usr/lib/{libcom_err,libe2p,libext2fs,libss}.a

gunzip -v $PCKDIR/usr/share/info/libext2fs.info.gz
install-info --dir-file=$PCKDIR/usr/share/info/dir $PCKDIR/usr/share/info/libext2fs.info
