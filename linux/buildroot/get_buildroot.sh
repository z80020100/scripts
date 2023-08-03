#!/bin/bash

# https://buildroot.org/download.html

BUILD_DIR=$HOME/build
DEFAULT_VERSION=latest
TARGET_VERSION=${1:-$DEFAULT_VERSION}
BUILDROOT_DIR=$BUILD_DIR/buildroot
BUILDROOT_GIT_URL=git://git.buildroot.net/buildroot
BUILDROOT_RELEASE_URL=https://buildroot.org/downloads/buildroot-$TARGET_VERSION.tar.gz
BUILDROOT_TAR_FILE_NAME=$(basename $BUILDROOT_RELEASE_URL)
if [ "$TARGET_VERSION" == "latest" ]; then
  BUILDROOT_TARGET_URL=$BUILDROOT_GIT_URL
else
  BUILDROOT_TARGET_URL=$BUILDROOT_RELEASE_URL
fi

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
  echo "  version: Buildroot version, default: $DEFAULT_VERSION"
  echo "Example: $0 2023.02.3"
  exit 1
}

function show_info() {
  echo "Target version: $TARGET_VERSION"
  echo "Buildroot directory: $BUILDROOT_DIR"
  echo "Download URL: $BUILDROOT_TARGET_URL"
}

function create_build_dir() {
  mkdir -p $BUILD_DIR
}

function remove_buildroot_dir() {
  if [ -d "$BUILDROOT_DIR" ]; then
    rm -rf $BUILDROOT_DIR
  fi
}

function get_latest_dev_version() {
  remove_buildroot_dir
  cd $BUILD_DIR
  git clone --depth 1 --branch master $BUILDROOT_TARGET_URL $BUILDROOT_DIR
}

function get_release_version() {
  remove_buildroot_dir
  cd $BUILD_DIR
  wget $BUILDROOT_TARGET_URL -O $BUILDROOT_TAR_FILE_NAME
  tar xvf $BUILDROOT_TAR_FILE_NAME
  mv buildroot-$TARGET_VERSION $BUILDROOT_DIR
}

function main() {
  if [ "$TARGET_VERSION" == "-h" ] || [ "$TARGET_VERSION" == "--help" ]; then
    usage
  fi
  show_info
  check_result create_build_dir
  if [ "$TARGET_VERSION" == "$DEFAULT_VERSION" ]; then
    check_result get_latest_dev_version
  else
    check_result get_release_version
  fi

}

main
