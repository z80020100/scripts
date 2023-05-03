#!/bin/bash

sudo pacman -Syu
sudo pacman -S linux-asahi-edge mesa-asahi-edge
sudo update-grub

../gui/install_kde_plasma_wayland_session_archlinux.sh
