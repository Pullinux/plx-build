
patch -Np1 -i $PCKBASE/files/coreutils-9.6-i18n-1.patch

autoreconf -fv
automake -af
FORCE_UNSAFE_CONFIGURE=1 ./configure \
            --prefix=/usr            \
            --enable-no-install-program=kill,uptime

make
make DESTDIR=$PCKDIR install

mkdir -p $PCKDIR/usr/sbin
mkdir -p $PCKDIR/usr/share/man/man8

mv -v $PCKDIR/usr/bin/chroot $PCKDIR/usr/sbin
mv -v $PCKDIR/usr/share/man/man1/chroot.1 $PCKDIR/usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/' $PCKDIR/usr/share/man/man8/chroot.8
