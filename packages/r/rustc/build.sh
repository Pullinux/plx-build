
mkdir -pv $PCKDIR/opt/rustc-1.85.0 
ln -svfn rustc-1.85.0 $PCKDIR/opt/rustc

cat << EOF > config.toml
# see config.toml.example for more possible options
# See the 8.4 book for an old example using shipped LLVM
# e.g. if not installing clang, or using a version before 13.0

# Tell x.py the editors have reviewed the content of this file
# and updated it to follow the major changes of the building system,
# so x.py will not warn us to do such a review.
change-id = 134650

[llvm]
# When using system llvm prefer shared libraries
link-shared = true

# Do not download pre-built LLVM, instead either use the system
# LLVM or build LLVM from the shipped source.
download-ci-llvm = false

# If building the shipped LLVM source, only enable the x86 target
# instead of all the targets supported by LLVM.
targets = "X86"

[build]
# omit docs to save time and space (default is to build them)
docs = false

# install extended tools: cargo, clippy, etc
extended = true

# Do not query new versions of dependencies online.
locked-deps = true

# Specify which extended tools (those from the default install).
tools = ["cargo", "clippy", "rustdoc", "rustfmt"]

[install]
prefix = "/opt/rustc-1.85.0"
docdir = "share/doc/rustc-1.85.0"

[rust]
channel = "stable"
description = "for BLFS 12.3"

# Enable the same optimizations as the official upstream build.
lto = "thin"
codegen-units = 1

[target.x86_64-unknown-linux-gnu]
llvm-config = "/usr/bin/llvm-config"

[target.i686-unknown-linux-gnu]
llvm-config = "/usr/bin/llvm-config"
EOF

sed '/MirOpt/d' -i src/bootstrap/src/core/builder/mod.rs

[ ! -e /usr/include/libssh2.h ] || export LIBSSH2_SYS_USE_PKG_CONFIG=1
[ ! -e /usr/include/sqlite3.h ] || export LIBSQLITE3_SYS_USE_PKG_CONFIG=1

./x.py build

DESTDIR=$PCKDIR ./x.py install rustc std 
DESTDIR=$PCKDIR ./x.py install --stage=1 cargo clippy rustfmt

rm -fv $PCKDIR/opt/rustc-1.85.0/share/doc/rustc-1.85.0/*.old   &&
install -vm644 README.md                                \
               $PCKDIR/opt/rustc-1.85.0/share/doc/rustc-1.85.0 &&

install -vdm755 $PCKDIR/usr/share/zsh/site-functions
ln -sfv /opt/rustc/share/zsh/site-functions/_cargo \
        $PCKDIR/usr/share/zsh/site-functions

mkdir -p $PCKDIR/usr/share/bash-completion/completions

mv -v $PCKDIR/etc/bash_completion.d/cargo $PCKDIR/usr/share/bash-completion/completions

mkdir -p $PCKDIR/etc/profile.d

cat > $PCKDIR/etc/profile.d/rustc.sh << "EOF"
# Begin /etc/profile.d/rustc.sh

pathprepend /opt/rustc/bin           PATH

# End /etc/profile.d/rustc.sh
EOF
