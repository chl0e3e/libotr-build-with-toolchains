# Build scripts for libotr using the Android toolchain

This repository contains build scripts used for the compilation of libotr on Android, as well as it's dependencies. First, you should download and extract the archives listed below into their own directories so that the script only has to change it's directory one directory below to execute `./configure`. Then, you can either tweak the `config.sh` or go straight ahead and run `./toolchain.sh`. Do not run `./build.sh` directly if you intend to compile for a specific toolchain, as this will only build the libraries for the host system and will not use any Android/iOS toolchains. After running `./toolchain.sh`, you can run `./copy.sh` and the script will copy out the binaries for each Android architecture into the `lib/` folder with the correct naming schemes.

Links
-----

- [Android NDK r25B for Linux](https://dl.google.com/android/repository/android-ndk-r25b-linux.zip)
- [libgcrypt 1.10.1](https://www.gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.10.1.tar.bz2)
- [libgpg-error 1.46](https://www.gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.46.tar.bz2)
- [libotr 4.1.1](https://otr.cypherpunks.ca/libotr-4.1.1.tar.gz)