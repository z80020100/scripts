#!/bin/bash

BUILD_DIR=$HOME/build
JOHN_CORE_VERSION="1.9.0"
JOHN_TARGET="john-$JOHN_CORE_VERSION"
JOHN_DIR=$BUILD_DIR/$JOHN_TARGET
JOHN_TARGET_SYSTEM_DEFAULT="generic"

OS=$(uname -s)
ARCH=$(uname -m)

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
  if [ "$OS" == "Linux" ]; then
    if [ "$ARCH" == "x86_64" ]; then
      JOHN_TARGET_SYSTEM="linux-x86-64"
    elif [ "$ARCH" == "aarch64" ]; then
      JOHN_TARGET_SYSTEM="linux-arm64le"
    else
      JOHN_TARGET_SYSTEM=$JOHN_TARGET_SYSTEM_DEFAULT
    fi
  else
    JOHN_TARGET_SYSTEM=$JOHN_TARGET_SYSTEM_DEFAULT
  fi
  echo "Build for $JOHN_TARGET_SYSTEM"
  cd $BUILD_DIR/$JOHN_TARGET/src
  make clean $JOHN_TARGET_SYSTEM
}

function main() {
  check_result build_john
}

main
