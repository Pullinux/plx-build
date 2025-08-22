sed '20,$ d' -i trust/trust-extract-compat &&

cat >> trust/trust-extract-compat << "EOF"
# Copy existing anchor modifications to /etc/ssl/local
/usr/libexec/make-ca/copy-trust-modifications

# Update trust stores
/usr/sbin/make-ca -r
EOF

mkdir __build && cd __build
meson setup --prefix=/usr --buildtype=release ..
ninja
DESTDIR=$PCKDIR ninja install

mkdir -p $PCKDIR/usr/bin

ln -sfv /usr/libexec/p11-kit/trust-extract-compat \
        $PCKDIR/usr/bin/update-ca-certificates

