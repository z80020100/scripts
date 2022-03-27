#!/bin/bash

sudo pacman -Syy
sudo pacman -S --noconfirm docker
sudo gpasswd -a $USER docker
