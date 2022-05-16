#!/bin/bash

BASEDIR=$(dirname "$0")
TB3_ENV_SETUP_FILE_PATH=$BASEDIR/envsetup.sh

source $TB3_ENV_SETUP_FILE_PATH

# https://navigation.ros.org/tutorials/docs/navigation2_with_slam.html#getting-started-simplification
function main()
{
  export TURTLEBOT3_MODEL=waffle
  export GAZEBO_MODEL_PATH=$GAZEBO_MODEL_PATH:$TB3_ROS2_WS_DIR/install/turtlebot3_gazebo/share/turtlebot3_gazebo/models
  ros2 launch nav2_bringup tb3_simulation_launch.py slam:=True
}

echo "NOTICE: it will take a long time to start Gazebo and has a chance of failing"
read -p "Press [Enter] to start or [Ctrl-C] to cancel..."
main
