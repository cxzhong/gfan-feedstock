#!/bin/bash

export CPPFLAGS="-DNOCDDPREFIX -DDISABLE_COMMENTATOR $CPPFLAGS"
export LDFLAGS="$LDFLAGS -lcddgmp -lgmp -lm"
export CFLAGS="-fPIC $CFLAGS"
export CXXFLAGS="-DNOCDDPREFIX -fPIC -I${PREFIX}/include/cddlib $CXXFLAGS -std=c++20"

if [[ "$target_platform" == osx-* ]]; then
  # On macOS, int64_t aliases long long int (not long int); define _64BITLONGINT
  # so that gfanlib_circuittableint.h enables the extra long long int overloads.
  export CXXFLAGS="$CXXFLAGS -fexperimental-library -D_64BITLONGINT"
  find ${SRC_DIR}/src -type f -print0 | xargs -0 sed -i '' "s/log2/logger2/g"
fi

make -j${CPU_COUNT}
if [[ "$CONDA_BUILD_CROSS_COMPILATION" != "1" && "$CROSSCOMPILING_EMULATOR" != "" ]]; then
  make check -j${CPU_COUNT} || true
fi
make install PREFIX="$PREFIX"
