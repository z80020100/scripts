#!/bin/bash
DISTRIB_CODENAME=$(lsb_release -c -s)
GCC_DEFAULT_VERSION=""
GCC_TARGET_VERSION=$GCC_DEFAULT_VERSION
GCC_VERSION_AVAILABLE_JAMMY=("9" "10" "11" "12")
GCC_VERSION_AVAILABLE_FOCAL=("9" "10")

function parse_available_versions() {
  GCC_VERSION_AVAILABLE=""
  if [ "$DISTRIB_CODENAME" == "jammy" ]; then
    version_list=("${GCC_VERSION_AVAILABLE_JAMMY[@]}")
  elif [ "$DISTRIB_CODENAME" == "focal" ]; then
    version_list=("${GCC_VERSION_AVAILABLE_FOCAL[@]}")
  else
    version_list=("unknown")
  fi
  for version in "${version_list[@]}"; do
    GCC_VERSION_AVAILABLE+="$version, "
  done
  GCC_VERSION_AVAILABLE="${GCC_VERSION_AVAILABLE%, }"
}

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

function parse_params() {
  while [ "$1" ]; do
    case "$1" in
    --help | -h)
      usage
      exit 0
      ;;
    --version | -v)
      GCC_TARGET_VERSION="$2"
      shift
      shift
      ;;
    *) ;;
    esac
  done

  if [ -z "$GCC_TARGET_VERSION" ]; then
    GCC_VERSION_SUFFIX=""
  else
    GCC_VERSION_SUFFIX="-$GCC_TARGET_VERSION"
  fi
}

function usage() {
  echo "Usage: $0 [options]"
  echo "options:"
  echo "  --version, -v: GCC version, available: $GCC_VERSION_AVAILABLE"
  echo "  --help, -h: display this help and exit"
  echo "Example: $0 -v 9"
}

function install_gcc() {
  sudo apt update && sudo apt install -y gcc$GCC_VERSION_SUFFIX g++$GCC_VERSION_SUFFIX
}

function main() {
  parse_available_versions
  parse_params "$@"
  check_result install_gcc
}

main "$@"
