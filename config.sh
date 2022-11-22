#!/bin/bash

VARIABLES_FILE=$(realpath "${BASH_SOURCE[${#BASH_SOURCE[@]} - 1]}")
VARIABLES_PATH=`realpath $(dirname $VARIABLES_FILE)`

ROOT="$VARIABLES_PATH"

NDK="$ROOT/android-ndk-r25b"
API="21"
HOST_ARCH=`uname -m`
GUEST_ABI=("armv7a-linux-androideabi aarch64-linux-android i686-linux-android x86_64-linux-android")

CONFIG_LIBGPG_ERROR="Y"
CONFIG_LIBGCRYPT="Y"
CONFIG_LIBOTR="Y"

LIBGPG_ERROR_VERSION="1.46"
LIBGCRYPT_VERSION="1.10.1"
LIBOTR_VERSION="4.1.1"

LIBGPG_ERROR_DIR="$ROOT/libgpg-error-$LIBGPG_ERROR_VERSION"
LIBGCRYPT_DIR="$ROOT/libgcrypt-$LIBGCRYPT_VERSION"
LIBOTR_DIR="$ROOT/libotr-$LIBOTR_VERSION"

# This directory ontains a set of system configurations for cross-compiling libgpg-error.
# These were generated via the instructions given on the gnupg mailing list:
# https://lists.gnupg.org/pipermail/gnupg-devel/2014-January/028202.html
LIBGPG_ERROR_SYSCFG_DIR="$ROOT/libgpg-error-syscfg"

TOOLCHAIN_DIR="$NDK/toolchains/llvm/prebuilt/linux-$HOST_ARCH"
TOOLCHAIN_BIN="$TOOLCHAIN_DIR/bin"

LOG_DIR="$ROOT/logs"
COPY_DIR="$ROOT/lib"
PREFIXES_DIR="$ROOT/prefixes"

ABI_FIX(){
   echo -n $1 | sed 's/armv7a/arm/'
}

ABI_TO_LIB(){
case $1 in
    arm-linux-androideabi)
        echo -n "armeabi-v7a"
        return 0
    ;;
    aarch64-linux-android)
        echo -n "arm64-v8a"
        return 0
    ;;
    i686-linux-android)
        echo -n "x86"
        return 0
    ;;
    x86_64-linux-android)
        echo -n "x86_64"
        return 0
    ;;
esac

   echo "unknown"
   return 0
}

if [ ! -d "${LOG_DIR}" ]; then
   mkdir $LOG_DIR
fi

if [ ! -d "${LOG_DIR}" ]; then
   echo "Toolchain not found, see README or run download.sh"
   exit 1
fi
