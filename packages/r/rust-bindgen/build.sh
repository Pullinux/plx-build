
cargo build --release 

mkdir -p $PCKDIR/usr/bin

install -v -m755 target/release/bindgen $PCKDIR/usr/bin

mkdir -p $PCKDIR//usr/share/bash-completion/completions/
mkdir -p $PCKDIR/usr/share/zsh/site-functions


