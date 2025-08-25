
cat > lua.pc << "EOF"
V=5.4
R=5.4.7

prefix=/usr
INSTALL_BIN=${prefix}/bin
INSTALL_INC=${prefix}/include
INSTALL_LIB=${prefix}/lib
INSTALL_MAN=${prefix}/share/man/man1
INSTALL_LMOD=${prefix}/share/lua/${V}
INSTALL_CMOD=${prefix}/lib/lua/${V}
exec_prefix=${prefix}
libdir=${exec_prefix}/lib
includedir=${prefix}/include

Name: Lua
Description: An Extensible Extension Language
Version: ${R}
Requires:
Libs: -L${libdir} -llua -lm -ldl
Cflags: -I${includedir}
EOF

patch -Np1 -i $PCKBASE/files/lua-5.4.7-shared_library-1.patch &&
make linux

make INSTALL_TOP=$PCKDIR/usr         \
     INSTALL_DATA="cp -d"            \
     INSTALL_MAN=$PCKDIR/usr/share/man/man1 \
     TO_LIB="liblua.so liblua.so.5.4 liblua.so.5.4.7" \
     install 

mkdir -p $PCKDIR/usr/lib/pkgconfig/

install -v -m644 -D lua.pc $PCKDIR/usr/lib/pkgconfig/lua.pc
