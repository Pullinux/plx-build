
./configure --prefix=/usr 

make

make DESTDIR=$PCKDIR install LN_S='ln -sfn'

