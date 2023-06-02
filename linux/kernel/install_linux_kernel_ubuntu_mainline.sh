#!/bin/bash

# https://kernel.ubuntu.com/~kernel-ppa/mainline/v6.1.28/
# V6.1.28 can be successfully installed on Ubuntu 22.04 (arm64) when tested on 2023/05/23
DEFAULT_VERSION="6.1.28"
TARGET_VERSION=${1:-$DEFAULT_VERSION}

echo "Target version: $TARGET_VERSION"

# https://linuxhint.com/install-upgrade-latest-kernel-ubuntu-22-04/
mainline --install $TARGET_VERSION
