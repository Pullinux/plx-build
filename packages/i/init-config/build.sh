
mkdir -p $PCKDIR/etc/systemd/network/

ln -s /dev/null $PCKDIR/etc/systemd/network/99-default.link

cat > $PCKDIR/etc/systemd/network/10-eth-dhcp.network << "EOF"
[Match]
Name=eth0

[Network]
DHCP=ipv4

[DHCPv4]
UseDomains=true
EOF

cat > $PCKDIR/etc/hostname << "EOF"
plx
EOF
	
cat > $PCKDIR/etc/hosts << "EOF"
127.0.0.1 localhost
EOF

cat > $PCKDIR/etc/adjtime << "EOF"
0.0 0 0.0
0
LOCAL
EOF

cat > $PCKDIR/etc/locale.conf << EOF
LANG=en_US.utf8
EOF

cat >  $PCKDIR/etc/plx-release << "EOF"
1.0
EOF

cat >  $PCKDIR/etc/lsb-release << "EOF"
DISTRIB_ID="Pullinux"
DISTRIB_RELEASE="1.0"
DISTRIB_CODENAME="LLD"
DISTRIB_DESCRIPTION="Pullinux"
EOF

cat >  $PCKDIR/etc/os-release << "EOF"
NAME="Pullinux"
VERSION="1.0"
ID=plx
PRETTY_NAME="Pullinux 1.0"
VERSION_CODENAME="lld"
HOME_URL="https://github.com/rockytriton"
RELEASE_TYPE="stable"
EOF

cat >  $PCKDIR/etc/resolv.conf << "EOF"
nameserver 8.8.8.8

EOF
