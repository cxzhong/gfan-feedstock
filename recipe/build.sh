#!/bin/bash

export CPPFLAGS="-DNOCDDPREFIX -DDISABLE_COMMENTATOR $CPPFLAGS"
export LDFLAGS="$LDFLAGS -lcddgmp -lgmp -lm"
export CFLAGS="-fPIC $CFLAGS"
export CXXFLAGS="-DNOCDDPREFIX -fPIC -I${PREFIX}/include/cddlib $CXXFLAGS"

if [[ "$target_platform" == "osx-64" ]]; then
  find ${SRC_DIR}/src -type f -print0 | xargs -0 sed -i '' "s/log2/logger2/g"
fi

make -j${CPU_COUNT}
make check
mkdir -p "$PREFIX/bin"
cp -pf gfan "$PREFIX/bin/"
cd "$PREFIX/bin"
gfan installlinks
