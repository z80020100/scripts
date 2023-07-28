#!/bin/bash

BUILD_DIR=$HOME/build
JOHN_CORE_VERSION="1.9.0"
JOHN_TARGET="john-$JOHN_CORE_VERSION"
JOHN_DIR=$BUILD_DIR/$JOHN_TARGET

DEFAULT_PASSWD="/etc/passwd"
DEFAULT_SHADOW="/etc/shadow"

TARGET_PASSWD=${1:-$DEFAULT_PASSWD}
TARGET_SHADOW=${2:-$DEFAULT_SHADOW}

UNSHADOWED_FILE="unshadowed.txt"
RESULT_FILE="john.pot"

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

function prepare() {
  cd $JOHN_DIR/run
  echo "Target passwd: $TARGET_PASSWD"
  echo "Target shadow: $TARGET_SHADOW"
  sudo ./unshadow $TARGET_PASSWD $TARGET_SHADOW > $UNSHADOWED_FILE
}

function john_brute_force() {
  cd $JOHN_DIR/run
  ./john $UNSHADOWED_FILE
}

function show_result() {
  echo "Result file: $RESULT_FILE"
  cd $JOHN_DIR/run
  cat $RESULT_FILE
}

function main() {
  check_result prepare
  check_result john_brute_force
  check_result show_result
}

main
