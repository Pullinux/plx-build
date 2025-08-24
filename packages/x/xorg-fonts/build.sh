
for package in $(grep -v '^#' font-7.md5 | awk '{print $2}')
do
  packagedir=${package%.tar.?z*}
  tar -xf $package
  pushd $packagedir
    ./configure $XORG_CONFIG
    make
    make DESTDIR=$PCKDIR install
  popd
  rm -rf $packagedir
done

