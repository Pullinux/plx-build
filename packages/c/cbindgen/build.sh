
cargo build --release

mkdir -p $PCKDIR/usr/bin/

install -Dm755 target/release/cbindgen $PCKDIR/usr/bin/
