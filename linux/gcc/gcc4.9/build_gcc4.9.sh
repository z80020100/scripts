#!/bin/bash

# https://gcc.gnu.org/install/download.html

# Global variable for timing
START_TIME=$(date +%s)

BUILD_DIR=$HOME/build
SCRIPT_PATH=$(
  cd "$(dirname "$0")"
  pwd
)
GCC_TARGET_VERSION="4.9"
GCC_DIR=$BUILD_DIR/gcc$GCC_TARGET_VERSION
GCC_SRC_DIR=$GCC_DIR/src
GCC_OBJ_DIR=$GCC_DIR/obj
# Use a file here to indicate that the patch has been applied
PATCH_APPLIED_FILE=$GCC_SRC_DIR/.patch_applied
PREREQUISITES_DOWNLOADED_FILE=$GCC_SRC_DIR/.prerequisites_downloaded

function check_result() {
  $@
  ERR=$?
  printf "$* "
  if [ "$ERR" != "0" ]; then
    echo -e "\033[47;31m [ERROR] $ERR \033[0m"
    END_TIME=$(date +%s)
    ELAPSED_TIME=$((END_TIME - START_TIME))
    echo -e "\033[41;37mBuild failed after ${ELAPSED_TIME} seconds\033[0m"
    exit 1
  else
    echo -e "\033[1;42m [OK] \033[0m"
  fi
}

create_obj_dir() {
  mkdir -p $GCC_OBJ_DIR
}

clean_build() {
  if [ -d "$GCC_OBJ_DIR" ]; then
    echo "Cleaning previous build cache"
    rm -rf $GCC_OBJ_DIR/*
  fi
}

function apply_patch() {
  if [ -f "$PATCH_APPLIED_FILE" ]; then
    echo "Patch has been applied"
    return
  fi
  if ls $SCRIPT_PATH/*.patch 1>/dev/null 2>&1; then
    cd $GCC_SRC_DIR
    git am $SCRIPT_PATH/*.patch
    touch $PATCH_APPLIED_FILE
  else
    echo "No need to apply patch"
  fi
}

function download_prerequisites() {
  if [ -f "$PREREQUISITES_DOWNLOADED_FILE" ]; then
    echo "Prerequisites have been downloaded"
    return
  fi
  cd $GCC_SRC_DIR
  ./contrib/download_prerequisites
  touch $PREREQUISITES_DOWNLOADED_FILE
}

function configure() {
  # Reference: ../src/configure -v --with-pkgversion='Ubuntu 11.3.0-1ubuntu1~22.04' --with-bugurl=file:///usr/share/doc/gcc-11/README.Bugs --enable-languages=c,ada,c++,go,d,fortran,objc,obj-c++,m2 --prefix=/usr --with-gcc-major-version-only --program-suffix=-11 --program-prefix=aarch64-linux-gnu- --enable-shared --enable-linker-build-id --libexecdir=/usr/lib --without-included-gettext --enable-threads=posix --libdir=/usr/lib --enable-nls --enable-bootstrap --enable-clocale=gnu --enable-libstdcxx-debug --enable-libstdcxx-time=yes --with-default-libstdcxx-abi=new --enable-gnu-unique-object --disable-libquadmath --disable-libquadmath-support --enable-plugin --enable-default-pie --with-system-zlib --enable-libphobos-checking=release --with-target-system-zlib=auto --enable-objc-gc=auto --enable-multiarch --enable-fix-cortex-a53-843419 --disable-werror --enable-checking=release --build=aarch64-linux-gnu --host=aarch64-linux-gnu --target=aarch64-linux-gnu --with-build-config=bootstrap-lto-lean --enable-link-serialization=2
  cd $GCC_OBJ_DIR
  ../src/configure -v --enable-languages=c,c++ --prefix=/usr --program-suffix=-4.9 --enable-shared --enable-linker-build-id --libexecdir=/usr/lib --without-included-gettext --enable-threads=posix --libdir=/usr/lib --enable-nls --enable-bootstrap --enable-clocale=gnu --enable-libstdcxx-debug --enable-libstdcxx-time=yes --with-default-libstdcxx-abi=new --enable-gnu-unique-object --disable-libquadmath --disable-libquadmath-support --enable-plugin --enable-default-pie --with-system-zlib --enable-libphobos-checking=release --with-target-system-zlib=auto --enable-objc-gc=auto --enable-multiarch --disable-werror --enable-checking=release --enable-link-serialization=2
}

function build() {
  cd $GCC_OBJ_DIR
  make bootstrap-lean -j
}

function main() {
  check_result clean_build
  check_result create_obj_dir
  check_result apply_patch
  check_result download_prerequisites
  check_result configure
  check_result build

  END_TIME=$(date +%s)
  ELAPSED_TIME=$((END_TIME - START_TIME))
  echo -e "\033[1;42mBuild completed successfully in ${ELAPSED_TIME} seconds\033[0m"
}

main
