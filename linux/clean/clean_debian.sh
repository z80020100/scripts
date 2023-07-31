#!/bin/bash

# https://manpages.ubuntu.com/manpages/jammy/en/man8/apt-get.8.html
# Clean clears out the local repository of retrieved package files
sudo apt clean

# Discard unused blocks on a mounted filesystem
sudo fstrim -v /
