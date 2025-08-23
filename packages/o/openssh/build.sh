
install -v -g sys -m700 -d /var/lib/sshd

groupadd -g 50 sshd

useradd  -c 'sshd PrivSep' \
         -d /var/lib/sshd  \
         -g sshd           \
         -s /bin/false     \
         -u 50 sshd

./configure --prefix=/usr                            \
            --sysconfdir=/etc/ssh                    \
            --with-privsep-path=/var/lib/sshd        \
            --with-default-path=/usr/bin             \
            --with-superuser-path=/usr/sbin:/usr/bin \
            --with-pid-dir=/run 

make
make DESTDIR=$PCKDIR install

mkdir -p $PCKDIR/usr/bin
mkdir -p $PCKDIR/usr/share/man/man1    

install -v -m755    contrib/ssh-copy-id $PCKDIR/usr/bin     &&

install -v -m644    contrib/ssh-copy-id.1 \
                    /usr/share/man/man1              &&
install -v -m755 -d /usr/share/doc/openssh-9.9p2     &&
install -v -m644    INSTALL LICENCE OVERVIEW README* \
                    /usr/share/doc/openssh-9.9p2

echo "PermitRootLogin no" >> $PCKDIR/etc/ssh/sshd_config


