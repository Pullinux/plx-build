
make mrproper

cp $PCKBASE/files/config .config

make

make INSTALL_MOD_PATH=$PCKDIR modules_install

mkdir -p $PCKDIR/boot

cp -iv arch/x86/boot/bzImage $PCKDIR/boot/vmlinuz-6.13.4-plx-1.0-systemd
cp -iv .config $PCKDIR/boot/config-6.13.4


