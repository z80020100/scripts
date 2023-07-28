#!/bin/bash

BUILD_DIR=$HOME/build
JOHN_CORE_VERSION="1.9.0"
JOHN_TARGET="john-$JOHN_CORE_VERSION"
JOHN_DIR=$BUILD_DIR/$JOHN_TARGET

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

function build_john() {
  cd $BUILD_DIR/$JOHN_TARGET/src
  make clean generic
}

function main() {
  check_result build_john
}

main
