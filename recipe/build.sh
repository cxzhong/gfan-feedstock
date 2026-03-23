#!/bin/bash

export CPPFLAGS="-DNOCDDPREFIX -DDISABLE_COMMENTATOR $CPPFLAGS"
export LDFLAGS="$LDFLAGS -lcddgmp -lgmp -lm"
export CFLAGS="-fPIC $CFLAGS"
export CXXFLAGS="-DNOCDDPREFIX -fPIC -std=c++20 -I${PREFIX}/include/cddlib $CXXFLAGS"

if [[ "$target_platform" == osx-* ]]; then
  export CXXFLAGS="$CXXFLAGS -fexperimental-library"
  find ${SRC_DIR}/src -type f -print0 | xargs -0 sed -i '' "s/log2/logger2/g"
fi

make -j${CPU_COUNT}
if [[ "$CONDA_BUILD_CROSS_COMPILATION" != "1" && "$CROSSCOMPILING_EMULATOR" != "" ]]; then
  make check -j${CPU_COUNT} || true
fi
make install PREFIX="$PREFIX"
