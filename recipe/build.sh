#!/bin/bash

if [[ $(uname) == Darwin ]]; then
  RPATH="-rpath ${PREFIX}/lib"
elif [[ $(uname) == Linux ]]; then
  RPATH="-Wl,-rpath,${PREFIX}/lib"
fi

### Build
CXXFLAGS="${CXXFLAGS} "-I${PREFIX}/include \
LDFLAGS="${LDFLAGS} -L${PREFIX}/lib ${RPATH}" \

mkdir -p build
cd build

cmake  \
   -DCMAKE_BUILD_TYPE=Release \
   -DCMAKE_INSTALL_PREFIX=$PREFIX \
   -DCMAKE_INSTALL_LIBDIR=$PREFIX/lib \
   -DBUILD_SHARED_LIBS=ON \
   -DCMAKE_AR=${AR} \
   -DCMAKE_RANLIB=${RANLIB} \
   ..
make -j ${CPU_COUNT}
make install

