pip3 wheel -w $PCKDIR/.install/dist --no-cache-dir --no-build-isolation --no-deps $PWD

install -vDm644 data/shell-completions/bash/meson $PCKDIR/usr/share/bash-completion/completions/meson
install -vDm644 data/shell-completions/zsh/_meson $PCKDIR/usr/share/zsh/site-functions/_meson
