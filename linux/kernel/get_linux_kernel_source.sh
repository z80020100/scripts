#!/bin/bash

BUILD_DIR=$HOME/build
LINUX_DIR=$BUILD_DIR/linux
# v6.1.29 is the latest LTS kernel as of 2023/05/17
DEFAULT_BRANCH=linux-6.1.y
TARGET_VERSION=${1:-$DEFAULT_BRANCH}

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

function usage() {
  echo "Usage: $0 [version]"
  echo "  version: linux kernel version, default: $DEFAULT_BRANCH"
  echo "Example: $0 v6.1.29"
  exit 1
}

function create_build_dir() {
  mkdir -p $BUILD_DIR
}

function clone_specific_branch() {
  cd $BUILD_DIR
  git clone --depth 1 --branch $TARGET_VERSION git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git $LINUX_DIR
  cd $LINUX_DIR
  git tag $TARGET_VERSION
}

function fetch_specific_branch() {
  cd $LINUX_DIR
  git tag | grep $TARGET_VERSION
  if [ "$?" != "0" ]; then
    git fetch --depth 1 origin $TARGET_VERSION
    git checkout FETCH_HEAD
    git tag -d $TARGET_VERSION
    git tag $TARGET_VERSION
  fi
}

function checkout_specific_branch() {
  cd $LINUX_DIR
  git checkout $TARGET_VERSION
}

function show_info() {
  echo "Linux directory: $LINUX_DIR"
  echo "Target version: $TARGET_VERSION"
}

function show_fetched_versions() {
  cd $LINUX_DIR
  echo "Current version: $(git describe --tags)"
  echo "Fetched versions:"
  git tag
}

function main() {
  if [ "$TARGET_VERSION" == "-h" ] || [ "$TARGET_VERSION" == "--help" ]; then
    usage
  fi
  show_info
  check_result create_build_dir
  if [ ! -d "$LINUX_DIR" ]; then
    check_result clone_specific_branch
  else
    check_result fetch_specific_branch
    check_result checkout_specific_branch
  fi
  show_fetched_versions
}

main
