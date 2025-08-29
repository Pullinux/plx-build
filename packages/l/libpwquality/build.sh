
./configure --prefix=/usr                      \
            --disable-static                   \
            --with-securedir=/usr/lib/security \
            --disable-python-bindings          
make 
pip3 wheel -w $PCKDIR/.install/dist --no-build-isolation --no-deps --no-cache-dir $PWD/python

make DESTDIR=$PCKDIR install

