
CPPFLAGS+=' -I /usr/include/python3.13' \
./configure --prefix=/usr               \
            --disable-static            \
            --with-default-dict=/usr/lib/cracklib/pw_dict 

make

make DESTDIR=$PCKDIR install

mkdir -p $PCKDIR/usr/share/dict/

xzcat $PCKBASE/files/cracklib-words-2.10.3.xz \
                       > $PCKDIR/usr/share/dict/cracklib-words       
ln -v -sf cracklib-words $PCKDIR/usr/share/dict/words                
echo $(hostname) >>      $PCKDIR/usr/share/dict/cracklib-extra-words 
install -v -m755 -d      $PCKDIR/usr/lib/cracklib                    



