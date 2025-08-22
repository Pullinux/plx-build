./configure --prefix=/usr        \
            --enable-shared      \
            --with-system-expat  \
            --enable-optimizations
make
make DESTDIR=$PCKDIR install

mkdir -p $PCKDIR/etc/

cat > $PCKDIR/etc/pip.conf << EOF
[global]
root-user-action = ignore
disable-pip-version-check = true
EOF

