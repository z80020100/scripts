#!/bin/bash

# https://crosstool-ng.github.io/download/

BUILD_DIR=$HOME/build
DEFAULT_VERSION=latest
TARGET_VERSION=${1:-$DEFAULT_VERSION}
# Remove the prefix "v" or "V" from the version string
TARGET_VERSION=${TARGET_VERSION#v}
TARGET_VERSION=${TARGET_VERSION#V}
CT_NG_DIR=$BUILD_DIR/crosstool-ng
CT_NG_GIT_URL=https://github.com/crosstool-ng/crosstool-ng.git
CT_NG_RELEASE_URL=http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-$TARGET_VERSION.tar.xz
CT_NG_TAR_FILE_NAME=$(basename $CT_NG_RELEASE_URL)
if [ "$TARGET_VERSION" == "latest" ]; then
  CT_NG_TARGET_URL=$CT_NG_GIT_URL
else
  CT_NG_TARGET_URL=$CT_NG_RELEASE_URL
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
  echo "  version: crosstool-NG version, default: $DEFAULT_VERSION"
  echo "Example: $0 v1.25.0"
  exit 1
}

function show_info() {
  echo "Target version: $TARGET_VERSION"
  echo "crosstool-NG directory: $CT_NG_DIR"
  echo "Download URL: $CT_NG_TARGET_URL"
}

function create_build_dir() {
  mkdir -p $BUILD_DIR
}

function remove_ct_ng_dir() {
  if [ -d "$CT_NG_DIR" ]; then
    rm -rf $CT_NG_DIR
  fi
}

function get_latest_dev_version() {
  remove_ct_ng_dir
  cd $BUILD_DIR
  git clone --depth 1 --branch master $CT_NG_TARGET_URL $CT_NG_DIR
}

function get_release_version() {
  remove_ct_ng_dir
  cd $BUILD_DIR
  wget $CT_NG_TARGET_URL -O $CT_NG_TAR_FILE_NAME
  tar xvf crosstool-ng-$TARGET_VERSION.tar.xz
  mv crosstool-ng-$TARGET_VERSION $CT_NG_DIR
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
