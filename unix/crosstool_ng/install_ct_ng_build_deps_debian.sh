#!/bin/bash

# https://github.com/crosstool-ng/crosstool-ng/blob/master/.github/workflows/continuous-integration-workflow.yml

sudo apt update && sudo apt install -y bison byacc build-essential flex \
  gawk git help2man \
  libncurses-dev libtool-bin texinfo unzip xz-utils
