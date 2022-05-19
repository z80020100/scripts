#!/bin/bash
BASEDIR=$(dirname "$0")
ROS2_DIR=~/ros2_galactic
ROS2_REPOS_FILE_NAME=ros2_galactic.repos
ROS2_REPOS_FILE_PATH=$BASEDIR/$ROS2_REPOS_FILE_NAME
ROS2_SCRIPT_FILE_NAME=$(basename "$0")
ROS2_SCRIPT_FILE_PATH=$BASEDIR/$ROS2_SCRIPT_FILE_NAME

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

function set_local()
{
  sudo apt update && sudo apt install locales -y
  sudo locale-gen en_US en_US.UTF-8
  sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
  export LANG=en_US.UTF-8
}

function add_ros2_apt_repo()
{
  sudo apt install software-properties-common -y
  sudo add-apt-repository universe
  sudo apt update && sudo apt install curl gnupg lsb-release -y
  sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(source /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
}

function install_dev_ros_tools()
{
  sudo apt update && sudo apt install -y \
    build-essential \
    cmake \
    git \
    python3-colcon-common-extensions \
    python3-flake8 \
    python3-pip \
    python3-pytest-cov \
    python3-rosdep \
    python3-setuptools \
    python3-vcstool \
    wget

  # install some pip packages needed for testing
  python3 -m pip install -U \
    flake8-blind-except \
    flake8-builtins \
    flake8-class-newline \
    flake8-comprehensions \
    flake8-deprecated \
    flake8-docstrings \
    flake8-import-order \
    flake8-quotes \
    pytest-repeat \
    pytest-rerunfailures \
    pytest \
    setuptools
}

function get_ros2()
{
  mkdir -p $ROS2_DIR/src
  cp $ROS2_REPOS_FILE_PATH $ROS2_DIR
  cp $ROS2_SCRIPT_FILE_PATH $ROS2_DIR
  cd $ROS2_DIR
  vcs import src < $ROS2_REPOS_FILE_NAME
}

function install_ros2_dependencies()
{
  cd $ROS2_DIR
  sudo rosdep init
  rosdep update
  export ROS_PYTHON_VERSION=3
  rosdep install --from-paths src --ignore-src -y --skip-keys "fastcdr rti-connext-dds-5.3.1 urdfdom_headers"
}

function main()
{
  check_result set_local
  check_result add_ros2_apt_repo
  check_result install_dev_ros_tools
  check_result get_ros2
  check_result install_ros2_dependencies
}

main
