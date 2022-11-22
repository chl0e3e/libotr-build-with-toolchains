#!/bin/bash

# copy out the Android ABI libraries into the script-level lib folder
# so that we can easily use them in Xamarin

source config.sh
cd $ROOT

if [ ! -d "${COPY_DIR}" ]; then echo "Creating folder with working binaries $COPY_DIR"
   mkdir -p $COPY_DIR
fi

for ABI in $GUEST_ABI;
do echo -e "\nCopying $ABI\n"
   ABI_FIXED=$(ABI_FIX $ABI)
   echo "$ABI fixed: $ABI_FIXED"
   LIB=$(ABI_TO_LIB $ABI_FIXED)
   echo "$ABI_FIXED directory: $LIB"
   LIB_DIR="$COPY_DIR/$LIB"

   if [ ! -d "${LIB_DIR}" ]; then echo "Creating folder for $ABI"
      mkdir -p $LIB_DIR
   fi

   cp $PREFIXES_DIR/$ABI_FIXED/lib/libotr.so $LIB_DIR
   cp $PREFIXES_DIR/$ABI_FIXED/lib/libgcrypt.so $LIB_DIR
   cp $PREFIXES_DIR/$ABI_FIXED/lib/libgpg-error.so $LIB_DIR

   find $LIB_DIR
done