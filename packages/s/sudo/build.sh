./configure --prefix=/usr              \
            --libexecdir=/usr/lib      \
            --with-secure-path         \
            --with-env-editor          \
            --docdir=/usr/share/doc/sudo-1.9.16p2 \
            --with-passprompt="[sudo] password for %p: " 
make
make DESTDIR=$PCKDIR install

cat > $PCKDIR/etc/sudoers.d/00-sudo << "EOF"
Defaults secure_path="/usr/sbin:/usr/bin"
%wheel ALL=(ALL) NOPASSWD: ALL
EOF

mkdir -p $PCKDIR/etc/pam.d
cat > $PCKDIR/etc/pam.d/sudo << "EOF"
# Begin /etc/pam.d/sudo

# include the default auth settings
auth      include     system-auth

# include the default account settings
account   include     system-account

# Set default environment variables for the service user
session   required    pam_env.so

# include system session defaults
session   include     system-session

# End /etc/pam.d/sudo
EOF
chmod 644 $PCKDIR/etc/pam.d/sudo
