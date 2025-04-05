#!/bin/bash
BASEDIR=$(dirname "$0")
ROS2_DIR=~/ros2_galactic
TB3_ROS2_WS_DIR=~/tb3_galactic_ws2
TB3_REPOS_FILE_NAME=turtlebot3_galactic.repos
TB3_REPOS_FILE_PATH=$BASEDIR/$TB3_REPOS_FILE_NAME
SETUP_COMPLETE_FLAG=$TB3_ROS2_WS_DIR/.setup_complete

function check_result()
{
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

function create_resouces()
{
  mkdir -p $TB3_ROS2_WS_DIR/src
  cp $TB3_REPOS_FILE_PATH $TB3_ROS2_WS_DIR
  cp $BASEDIR/*.sh $TB3_ROS2_WS_DIR
}

function get_tb3_ros2()
{
  cd $TB3_ROS2_WS_DIR
  vcs import src < $TB3_REPOS_FILE_NAME
}

function mark_setup_complete()
{
  touch $SETUP_COMPLETE_FLAG
}

function is_setup_complete()
{
  if [ -f "$SETUP_COMPLETE_FLAG" ]; then
    return 0
  fi
  return 1
}

function check_setup_status()
{
  if is_setup_complete; then
    echo "Environment is already set up"
    return 0
  fi
  echo "Environment setup is needed"
  return 1
}
