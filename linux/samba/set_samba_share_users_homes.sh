#!/bin/bash

sudo tee -a /etc/samba/smb.conf << EOF
[homes]
   comment = Home Directories
   path = /home/%S
   valid users = %S
   writable = yes
   browseable = yes
   create mask = 0644
   directory mask = 0755

EOF
