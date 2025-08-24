export QT6PREFIX=/opt/qt6

./configure -prefix $QT6PREFIX      \
            -sysconfdir /etc/xdg    \
            -dbus-linked            \
            -openssl-linked         \
            -system-sqlite          \
            -nomake examples        \
            -no-rpath               \
            -journald               \
            -skip qt3d              \
            -skip qtquick3dphysics  \
            -skip qtwebengine
ninja
DESTDIR=$PCKDIR ninja install

find $PCKDIR/$QT6PREFIX/ -name \*.prl \
   -exec sed -i -e '/^QMAKE_PRL_BUILD_DIR/d' {} \;

mkdir -p $PCKDIR/usr/share/pixmaps/

pushd qttools/src 

install -v -Dm644 assistant/assistant/images/assistant-128.png       \
                  $PCKDIR/usr/share/pixmaps/assistant-qt6.png               

install -v -Dm644 designer/src/designer/images/designer.png          \
                  $PCKDIR/usr/share/pixmaps/designer-qt6.png                

install -v -Dm644 linguist/linguist/images/icons/linguist-128-32.png \
                  $PCKDIR/usr/share/pixmaps/linguist-qt6.png                

install -v -Dm644 qdbus/qdbusviewer/images/qdbusviewer-128.png       \
                  $PCKDIR/usr/share/pixmaps/qdbusviewer-qt6.png             
popd

mv $PCKDIR/opt/qt6 $PCKDIR/opt/qt-6.8.2
