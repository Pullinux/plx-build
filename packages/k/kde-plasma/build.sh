
#need to get this one, it's too big for github.
wget https://download.kde.org/stable/plasma/6.3.2/plasma-workspace-wallpapers-6.3.2.tar.xz -P $PCKBASE/files/

while read -r line; do

    # Get the file name, ignoring comments and blank lines
    if $(echo $line | grep -E -q '^ *$|^#' ); then continue; fi
    file=$(echo $line | cut -d" " -f2)

    pkg=$(echo $file|sed 's|^.*/||')           # Remove directory
    packagedir=$(echo $pkg |sed 's|\.tar.*||') # Source directory

    tar -xf $PCKBASE/files/$file
    pushd $packagedir

       mkdir build
       cd    build

       cmake -D CMAKE_INSTALL_PREFIX=$KF6_PREFIX \
             -D CMAKE_INSTALL_LIBEXECDIR=libexec \
             -D CMAKE_BUILD_TYPE=Release         \
             -D BUILD_QT5=OFF                    \
             -D BUILD_TESTING=OFF                \
             -W no-dev ..  &&

        make
        make DESTDIR=$PCKDIR install
        make install
    popd

    rm -rf $packagedir
    /sbin/ldconfig

done < $PCKBASE/files/plasma-6.3.2.md5
