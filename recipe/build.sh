#!/bin/bash

if [[ $(uname) == Darwin ]]; then
  RPATH="-rpath ${PREFIX}/lib"
elif [[ $(uname) == Linux ]]; then
  RPATH="-Wl,-rpath,${PREFIX}/lib"
fi

### Build
CXXFLAGS="${CXXFLAGS} "-I${PREFIX}/include \
LDFLAGS="${LDFLAGS} -L${PREFIX}/lib ${RPATH}" \
make -j ${CPU_COUNT}

### Check
make check

### Install manually ( no make install :) )
# Ensure there is somewhere to put this stuff
mkdir -p ${PREFIX}/include
mkdir -p ${PREFIX}/lib

# Move the libs, fixing any dylib's id name
dylibs=$(find out-shared -type f -name "*.dylib.*")
for dylib in $dylibs; do
  install_name_tool -id $(basename $dylib) $dylib
  mv $dylib ${PREFIX}/lib/
done
mv out-shared/libleveldb.* ${PREFIX}/lib/ || true
# These libs are not really static; they link to the
# snappy shared library, I think.
mv out-static/libleveldb.* ${PREFIX}/lib/
# .. only exists for static
mv out-static/libmemenv.* ${PREFIX}/lib/

# Move over the includes
mv include/leveldb ${PREFIX}/include/
