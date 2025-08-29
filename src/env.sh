export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"
export NINJAJOBS=$(nproc)
export QT6PREFIX=/opt/qt6
export MAKEFLAGS="-j$(nproc)"
export KF6_PREFIX=/opt/kf6
