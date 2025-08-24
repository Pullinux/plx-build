
tar -xf $PCKBASE/files/llvm-cmake-19.1.7.src.tar.xz                              
tar -xf $PCKBASE/files/llvm-third-party-19.1.7.src.tar.xz                        
sed '/LLVM_COMMON_CMAKE_UTILS/s@../cmake@cmake-19.1.7.src@'          \
    -i CMakeLists.txt                                                
sed '/LLVM_THIRD_PARTY_DIR/s@../third-party@third-party-19.1.7.src@' \
    -i cmake/modules/HandleLLVMOptions.cmake

tar -xf $PCKBASE/files/clang-19.1.7.src.tar.xz -C tools &&
mv tools/clang-19.1.7.src tools/clang

tar -xf $PCKBASE/files/compiler-rt-19.1.7.src.tar.xz -C projects    &&
mv projects/compiler-rt-19.1.7.src projects/compiler-rt

grep -rl '#!.*python' | xargs sed -i '1s/python$/python3/'
sed 's/utility/tool/' -i utils/FileCheck/CMakeLists.txt

mkdir -v build 
cd       build 

CC=gcc CXX=g++                               \
cmake -D CMAKE_INSTALL_PREFIX=/usr           \
      -D CMAKE_SKIP_INSTALL_RPATH=ON         \
      -D LLVM_ENABLE_FFI=ON                  \
      -D CMAKE_BUILD_TYPE=Release            \
      -D LLVM_BUILD_LLVM_DYLIB=ON            \
      -D LLVM_LINK_LLVM_DYLIB=ON             \
      -D LLVM_ENABLE_RTTI=ON                 \
      -D LLVM_TARGETS_TO_BUILD="host;AMDGPU" \
      -D LLVM_BINUTILS_INCDIR=/usr/include   \
      -D LLVM_INCLUDE_BENCHMARKS=OFF         \
      -D CLANG_DEFAULT_PIE_ON_LINUX=ON       \
      -D CLANG_CONFIG_FILE_SYSTEM_DIR=/etc/clang \
      -W no-dev -G Ninja ..

ninja
DESTDIR=$PCKDIR ninja install

mkdir -pv $PCKDIR/etc/clang &&
for i in clang clang++; do
  echo -fstack-protector-strong > $PCKDIR/etc/clang/$i.cfg
done
