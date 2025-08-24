
curl -LO https://github.com/lu-zero/cargo-c/releases/download/v0.10.11/Cargo.lock

[ ! -e /usr/include/libssh2.h ] || export LIBSSH2_SYS_USE_PKG_CONFIG=1    &&
[ ! -e /usr/include/sqlite3.h ] || export LIBSQLITE3_SYS_USE_PKG_CONFIG=1 &&

cargo build --release

mkdir -p $PCKDIR/usr/bin/

install -vm755 target/release/cargo-{capi,cbuild,cinstall,ctest} $PCKDIR/usr/bin/
