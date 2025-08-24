
for package in $(grep -v '^#' app-7.md5 | awk '{print $2}')
do
  packagedir=${package%.tar.?z*}
  tar -xf $package
  pushd $packagedir
     ./configure $XORG_CONFIG
     make
     make DESTDIR=$PCKDIR install
     make install
  popd
  rm -rf $packagedir
done

rm -f $XORG_PREFIX/bin/xkeystone
rm -f $PCKDIR/$XORG_PREFIX/bin/xkeystone
