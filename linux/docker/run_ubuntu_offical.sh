#!/bin/bash
# https://hub.docker.com/_/ubuntu

DEFAULT_VERSION="latest"
VERSION=${1:-$DEFAULT_VERSION}

function usage() {
  echo "Usage: $0 [version]"
  echo "  version: Ubuntu version, default: $DEFAULT_VERSION"
  echo "Example: $0 22.04"
}

function run() {
  docker run -it ubuntu:$VERSION /bin/bash
}

function main() {
  if [ "$VERSION" == "-h" ] || [ "$VERSION" == "--help" ]; then
    usage
    exit 1
  fi
  run
}

main
