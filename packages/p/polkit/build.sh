
groupadd -fg 27 polkitd
useradd -c "PolicyKit Daemon Owner" -d /etc/polkit-1 -u 27 \
        -g polkitd -s /bin/false polkitd

mkdir __build && cd __build
meson setup ..                   \
      --prefix=/usr              \
      --buildtype=release        \
      -D man=true                \
      -D session_tracking=logind \
      -D tests=true
ninja
DESTDIR=$PCKDIR ninja install
