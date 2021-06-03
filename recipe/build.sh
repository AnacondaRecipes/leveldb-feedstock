#!/bin/bash

mkdir build
pushd build
cmake \
  -GNinja \
  -DBUILD_SHARED_LIBS=ON \
  -DLEVELDB_BUILD_TESTS=OFF \
  -DLEVELDB_BUILD_BENCHMARKS=OFF \
  -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -DCMAKE_INSTALL_LIBDIR=$PREFIX/lib \
  ..
ninja install
popd