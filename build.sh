#!/bin/bash

source config.sh
cd $ROOT

# this script expects an ABI to compile for (there is a list of possible ABIs in config.sh)
# the script expects that the compiler variables are already configured (this is done in toolchain.sh)
TARGET_ABI="$1"

if [ -z "$TARGET_ABI" ]; then echo "Assuming target ABI is a GNU/Linux host (if you are building for Android, use ./toolchain.sh)"
   TARGET_ABI="$HOST_ARCH-linux-gnu"
fi

TARGET_OUT="$PREFIXES_DIR/$TARGET_ABI"

if [ ! -d "${TARGET_OUT}" ]; then echo "Creating output directory $TARGET_OUT"
   mkdir -p $TARGET_OUT
fi

if [ "$CONFIG_LIBGPG_ERROR" != "N" ]; then echo "Building libgpg-error target $TARGET_ABI in $LIBGPG_ERROR_DIR to $TARGET_OUT"
   cd "$LIBGPG_ERROR_DIR"

   # patch in the syscfg files we have pre-generated using the Android Device Manager
   echo "Copying in libgpg-error system configurations"
   cp "$LIBGPG_ERROR_SYSCFG_DIR/*.h" "$LIBGPG_ERROR_DIR/src/syscfg/"

   export CFLAGS="-fPIE -fPIC"
   export LDFLAGS="-pie"
   ./configure --enable-install-gpg-error-config --host="$TARGET_ABI" --prefix="$TARGET_OUT" || exit 1
   make clean || exit 2
   make 2>&1 || exit 3
   make install 2>&1 || exit 4
fi

if [ "$CONFIG_LIBGCRYPT" != "N" ]; then echo "Building libgcrypt target $TARGET_ABI in $LIBGCRYPT_DIR to $TARGET_OUT"
   cd "$LIBGCRYPT_DIR"

   echo "Patching libgcrypt to not build tests (incompatible assembly)"
   sed -i 's/ tests//' Makefile.in

   export CFLAGS="-fPIE -fPIC"
   export LDFLAGS="-pie"
   ./configure --with-libgpg-error-prefix="$TARGET_OUT" --host="$TARGET_ABI" --prefix="$TARGET_OUT" || exit 5
   make clean || exit 6
   make 2>&1 || exit 7
   make install 2>&1 || exit 8
fi

if [ "$CONFIG_LIBOTR" != "N" ]; then echo "Building libotr target $TARGET_ABI in $LIBOTR_DIR to $TARGET_OUT"
   cd "$LIBOTR_DIR"

   echo "Patching libotr to not build tests (NDK does not support libpthread)"
   sed -i 's/\$(am__append_1)//' Makefile.in
   sed -i 's/@BUILD_TESTS_TRUE@am__append_1 = tests//' Makefile.in
   sed -i 's/ tests//' Makefile.in

   export CFLAGS="-fPIE -fPIC"
   export LDFLAGS="-pie"
   ./configure --with-libgcrypt-prefix="$TARGET_OUT" --host="$TARGET_ABI" --prefix="$TARGET_OUT" || exit 9
   make clean || exit 10 
   make 2>&1 || exit 11
   make install 2>&1 || exit 12
fi

echo "Built complete with all successful exit codes"
exit 0