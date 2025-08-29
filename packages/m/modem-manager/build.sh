
./configure --prefix=/usr                 \
            --sysconfdir=/etc             \
            --localstatedir=/var          \
            --disable-static              \
            --disable-maintainer-mode     \
            --with-systemd-journal        \
            --with-systemd-suspend-resume

make

make DESTDIR=$PCKDIR install

