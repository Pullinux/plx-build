
patch -Np1 -i $PCKBASE/files/mesa-add_xdemos-4.patch

mkdir build 
cd    build 

meson setup ..                 \
      --prefix=$XORG_PREFIX    \
      --buildtype=release      \
      -D platforms=x11,wayland \
      -D gallium-drivers=auto  \
      -D vulkan-drivers=auto   \
      -D valgrind=disabled     \
      -D video-codecs=all      \
      -D libunwind=disabled

ninja

DESTDIR=$PCKDIR ninja install

