#!/bin/bash

SCRIPT_PATH=$(
  cd "$(dirname "$0")"
  pwd
)
cd $SCRIPT_PATH
source ../../../envsetup.sh
# ct-ng upgradeconfig
ct-ng build
