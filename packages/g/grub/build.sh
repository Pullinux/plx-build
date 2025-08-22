echo depends bli part_gpt > grub-core/extra_deps.lst

./configure --prefix=/usr          \
            --sysconfdir=/etc      \
            --disable-efiemu       \
            --disable-werror
make
make DESTDIR=$PCKDIR install

mkdir -p $PCKDIR/usr/share/bash-completion/completions

mv -v $PCKDIR/etc/bash_completion.d/grub $PCKDIR/usr/share/bash-completion/completions
