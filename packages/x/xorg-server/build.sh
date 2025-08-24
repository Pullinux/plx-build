
patch -Np1 -i $PCKBASE/files/xorg-server-21.1.16-tearfree_backport-1.patch

mkdir __build && cd __build
meson setup ..              \
      --prefix=$XORG_PREFIX \
      --localstatedir=/var  \
      -D glamor=true        \
      -D xkb_output_dir=/var/lib/xkb
ninja
DESTDIR=$PCKDIR ninja install
mkdir -pv $PCKDIR/etc/X11/xorg.conf.d
