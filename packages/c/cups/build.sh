
useradd -c "Print Service User" -d /var/spool/cups -g lp -s /bin/false -u 9 lp || true
groupadd -g 19 lpadmin || true

./configure --libdir=/usr/lib            \
            --with-rundir=/run/cups      \
            --with-system-groups=lpadmin \
            --with-docdir=/usr/share/cups/doc-2.4.11

make

make DESTDIR=$PCKDIR install

