
mkdir -p $PCKDIR/usr

./bootstrap.sh --prefix=$PCKDIR/usr --with-python=python3 
./b2 stage -j$(nproc) threading=multi link=shared
./b2 --prefix=$PCKDIR/usr install threading=multi link=shared
