
mkdir build 
cd    build 

../configure --prefix=/usr          \
             --with-system-readline \
             --with-python=/usr/bin/python3

make


make -C gdb DESTDIR=$PCKDIR install 
make -C gdbserver DESTDIR=$PCKDIR install
