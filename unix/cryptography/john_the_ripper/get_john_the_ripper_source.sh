#!/bin/bash

BUILD_DIR=$HOME/build
JOHN_CORE_VERSION="1.9.0"
JOHN_TARGET="john-$JOHN_CORE_VERSION"
JOHN_SRC_URL=https://www.openwall.com/john/k/$JOHN_TARGET.tar.xz
JOHN_TAR_FILE_NAME=$(basename $JOHN_SRC_URL)

function check_result() {
  $@
  ERR=$?
  printf "$* "
  if [ "$ERR" != "0" ]; then
    echo -e "\033[47;31m [ERROR] $ERR \033[0m"
    exit 1
  else
    echo -e "\033[1;42m [OK] \033[0m"
  fi
}

function create_build_dir() {
  mkdir -p $BUILD_DIR
}

function get_john_source() {
  echo "Download $JOHN_SRC_URL to $BUILD_DIR"
  cd $BUILD_DIR
  wget $JOHN_SRC_URL -O $JOHN_TAR_FILE_NAME
  echo "Extract $JOHN_TAR_FILE_NAME"
  tar -xvf $JOHN_TAR_FILE_NAME
}

function main() {
  check_result create_build_dir
  check_result get_john_source
}

main
