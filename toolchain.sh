#!/bin/bash

source config.sh
cd $ROOT

echo "Toolchain: $TOOLCHAIN_DIR"

export RANLIB="$TOOLCHAIN_BIN/llvm-ranlib"
export LD="$TOOLCHAIN_BIN/ld"
export AR="$TOOLCHAIN_BIN/llvm-ar"
export STRIP="$TOOLCHAIN_BIN/llvm-strip"

echo ""
echo "ranlib: $RANLIB"
echo "ld    : $LD"
echo "ar    : $AR"

for ABI in $GUEST_ABI;
do echo "Compiling for $ABI"
   TOOLCHAIN_BINARY_PREFIX="$TOOLCHAIN_BIN/$ABI$API"
   export CC="$TOOLCHAIN_BINARY_PREFIX-clang"
   export CXX="$TOOLCHAIN_BINARY_PREFIX-clang++"
   export AS="$CC"

echo "cc    : $CC"
echo "cxx   : $CXX"
echo "api   : $API"
echo "abi   : $ABI"
echo "arch  : $ABI$API"

   ./build.sh $(ABI_FIX $ABI) || exit 1
done

