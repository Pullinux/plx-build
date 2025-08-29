
patch -Np1 -i $PCKBASE/files/gpm-1.20.7-consolidated-1.patch                
./autogen.sh                                                    
./configure --prefix=/usr --sysconfdir=/etc ac_cv_path_emacs=no 

make

make DESTDIR=$PCKDIR install

mkdir -p $PCKDIR/usr/share/info
mkdir -p $PCKDIR/usr/lib
mkdir -p $PCKDIR/etc

install-info --dir-file=/usr/share/info/dir           \
             $PCKDIR/usr/share/info/gpm.info                 

rm -fv $PCKDIR/usr/lib/libgpm.a                              
ln -sfv libgpm.so.2.1.0 $PCKDIR/usr/lib/libgpm.so            
install -v -m644 conf/gpm-root.conf $PCKDIR/etc 
