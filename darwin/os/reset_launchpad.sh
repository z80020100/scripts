#!/bin/bash

defaults write com.apple.dock ResetLaunchPad -bool true
# Provide by DeepSeek
trash /private$(getconf DARWIN_USER_DIR)com.apple.dock.launchpad
killall Dock
