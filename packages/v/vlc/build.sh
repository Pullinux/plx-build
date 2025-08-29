patch -Np1 -i $PCKBASE/files/vlc-3.0.21-taglib-1.patch         
patch -Np1 -i $PCKBASE/files/vlc-3.0.21-fedora_ffmpeg7-1.patch

BUILDCC=gcc ./configure --prefix=/usr --disable-libplacebo

make

make docdir=/usr/share/doc/vlc-3.0.21 DESTDIR=$PCKDIR install

