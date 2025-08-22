echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h

./configure --prefix=/usr
make
make DESTDIR=$PCKDIR install

ln -sv vim $PCKDIR/usr/bin/vi
for L in  $PCKDIR/usr/share/man/{,*/}man1/vim.1; do
    ln -sv vim.1 $(dirname $L)/vi.1
done

mkdir -p $PCKDIR/usr/share/doc/

ln -sv ../vim/vim91/doc $PCKDIR/usr/share/doc/vim-9.1.1166
