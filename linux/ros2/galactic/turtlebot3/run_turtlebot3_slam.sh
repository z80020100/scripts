#!/bin/bash

BASEDIR=$(dirname "$0")
TB3_ENV_SETUP_FILE_PATH=$BASEDIR/envsetup.sh

source $TB3_ENV_SETUP_FILE_PATH

function main()
{
  ros2 launch turtlebot3_cartographer cartographer.launch.py use_sim_time:=True
}

main
