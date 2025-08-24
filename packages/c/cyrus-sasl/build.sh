sed '/saslint/a #include <time.h>'       -i lib/saslutil.c 
sed '/plugin_common/a #include <time.h>' -i plugins/cram.c

./configure --prefix=/usr                       \
            --sysconfdir=/etc                   \
            --enable-auth-sasldb                \
            --with-dblib=lmdb                   \
            --with-dbpath=/var/lib/sasl/sasldb2 \
            --with-sphinx-build=no              \
            --with-saslauthd=/var/run/saslauthd

make -j1

make DESTDIR=$PCKDIR install

install -v -dm700 $PCKDIR/var/lib/sasl
