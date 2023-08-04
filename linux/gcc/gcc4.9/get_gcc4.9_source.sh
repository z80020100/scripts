#!/bin/bash

# https://gcc.gnu.org/install/download.html

BUILD_DIR=$HOME/build
GCC_TARGET_VERSION="4.9"
GCC_DIR=$BUILD_DIR/gcc$GCC_TARGET_VERSION
GCC_GIT_URL=git://gcc.gnu.org/git/gcc.git
GCC_GIT_TARGET_BRANCH="releases/gcc-$GCC_TARGET_VERSION"
GCC_SRC_DIR=$GCC_DIR/src

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

function remove_gcc_dir() {
  if [ -d "$GCC_DIR" ]; then
    rm -rf $GCC_DIR
  fi
}

function get_gcc_source() {
  remove_gcc_dir
  cd $BUILD_DIR
  git clone --depth 1 --branch $GCC_GIT_TARGET_BRANCH $GCC_GIT_URL $GCC_SRC_DIR
}

function main() {
  create_build_dir
  check_result get_gcc_source

}

main
