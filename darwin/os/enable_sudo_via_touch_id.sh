#!/bin/bash

sudo sed -i -- '2s/^/auth       sufficient     pam_tid.so\n/' /etc/pam.d/sudo
