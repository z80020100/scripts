#!/bin/bash
BASEDIR=$(dirname "$0")
ROS2_DIR=~/ros2_galactic
TB3_ROS2_WS_DIR=~/tb3_ws2
TB3_ENV_SETUP_FILE_PATH=$BASEDIR/envsetup.sh

source $TB3_ENV_SETUP_FILE_PATH

function main()
{
  ros2 run turtlebot3_teleop teleop_keyboard
}

main
