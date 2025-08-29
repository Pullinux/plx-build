grep -rl '^#!.*python$' | xargs sed -i '1s/python/&3/'

mkdir -v __build 
cd       __build 

cmake -G "Unix Makefiles"          \
      -D CMAKE_BUILD_TYPE=Release  \
      -D CMAKE_INSTALL_PREFIX=/usr \
      -D build_wizard=ON           \
      -D force_qt=Qt6              \
      -W no-dev ..
      
make

make DESTDIR=$PCKDIR install

