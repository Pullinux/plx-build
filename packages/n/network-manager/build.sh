
grep -rl '^#!.*python$' | xargs sed -i '1s/python/&3/'

mkdir __build && cd __build
meson setup ..                    \
      --prefix=/usr               \
      --buildtype=release         \
      -D libaudit=no              \
      -D nmtui=true               \
      -D ovs=false                \
      -D ppp=false                \
      -D selinux=false            \
      -D qt=false                 \
      -D session_tracking=systemd \
      -D modem_manager=false 
ninja
DESTDIR=$PCKDIR ninja install

mv -v $PCKDIR/usr/share/doc/NetworkManager{,-1.50.0}
