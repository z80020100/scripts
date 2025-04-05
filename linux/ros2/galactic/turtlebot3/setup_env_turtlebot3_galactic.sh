#!/bin/bash
SCRIPT_DIR=$(dirname "$0")
source $SCRIPT_DIR/common.sh

function install_tb3_ros2_dependencies()
{
  cd $TB3_ROS2_WS_DIR
  export ROS_PYTHON_VERSION=3
  rosdep install --from-paths src --ignore-src -r -y
}

function main()
{
  create_resouces
  check_result get_tb3_ros2
  check_result install_tb3_ros2_dependencies
}

main
