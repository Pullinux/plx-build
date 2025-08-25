
patch -Np1 -i $PCKBASE/files/nss-standalone-1.patch 

cd nss 

make BUILD_OPT=1                      \
  NSPR_INCLUDE_DIR=/usr/include/nspr  \
  USE_SYSTEM_ZLIB=1                   \
  ZLIB_LIBS=-lz                       \
  NSS_ENABLE_WERROR=0                 \
  $([ $(uname -m) = x86_64 ] && echo USE_64=1) \
  $([ -f /usr/include/sqlite3.h ] && echo NSS_USE_SYSTEM_SQLITE=1)

cd ../dist                                                          

mkdir -p $PCKDIR/usr/lib
mkdir -p $PCKDIR/usr/bin
mkdir -p $PCKDIR/usr/lib/pkgconfig

install -v -m755 Linux*/lib/*.so              $PCKDIR/usr/lib              
install -v -m644 Linux*/lib/{*.chk,libcrmf.a} $PCKDIR/usr/lib              

install -v -m755 -d                           $PCKDIR/usr/include/nss      
cp -v -RL {public,private}/nss/*              $PCKDIR/usr/include/nss      

install -v -m755 Linux*/bin/{certutil,nss-config,pk12util} $PCKDIR/usr/bin 

install -v -m644 Linux*/lib/pkgconfig/nss.pc  $PCKDIR/usr/lib/pkgconfig

ln -sfv ./pkcs11/p11-kit-trust.so $PCKDIR/usr/lib/libnssckbi.so
