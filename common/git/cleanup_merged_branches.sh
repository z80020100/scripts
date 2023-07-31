#!/bin/bash

TARGET_GIT_REPO_PATH=$1

function usage() {
  echo "Usage: $0 <target git repo path>"
  echo "Example: $0 ."
}

function confirm() {
  cd $TARGET_GIT_REPO_PATH
  TARGET_GIT_REPO_ROOT=$(git rev-parse --show-toplevel)
  if [ "$TARGET_GIT_REPO_ROOT" == "" ]; then
    echo "$TARGET_GIT_REPO_PATH is not a Git repository"
    exit 1
  fi
  echo -e "\033[1;42m Target Git repository: $TARGET_GIT_REPO_ROOT \033[0m"
  echo -e "\033[47;31m [DANGER] The following branches will be deleted: \033[0m"
  git branch --merged | grep -v "\*" | grep -v "master" | grep -v "main"
  read -p "Continue? [y/N] " ans
  case $ans in
  [Yy]*) ;;
  *)
    echo "Abort"
    exit 1
    ;;
  esac
}

function cleanup() {
  cd $TARGET_GIT_REPO_ROOT
  git branch --merged | grep -v "\*" | grep -v "master" | grep -v "main" | xargs -n 1 git branch -d
  git fetch --prune
  git gc
}

function main() {
  if [ "$TARGET_GIT_REPO_PATH" == "" ]; then
    usage
    exit 1
  fi
  confirm
  cleanup
}

main
