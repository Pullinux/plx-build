
mkdir bld &&
cd    bld &&

cmake -D CMAKE_INSTALL_PREFIX=/usr \
      -D GIT_ARCHETYPE=1           \
      -W no-dev                    \
      ../source

make

make DESTDIR=$PCKDIR install

rm -vf $PCKDIR/usr/lib/libx265.a
