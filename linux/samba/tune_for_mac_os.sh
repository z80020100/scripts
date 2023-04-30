#!/bin/bash

# https://wiki.samba.org/index.php/Configure_Samba_to_Work_Better_with_Mac_OS_X
sudo tee -a /etc/samba/smb.conf << EOF
[global]
## Enhanced OS X and Netatalk interoperability (vfs_fruit)
   min protocol = SMB2
   ea support = yes
   vfs objects = fruit streams_xattr
   fruit:metadata = stream
   fruit:model = MacSamba
   fruit:veto_appledouble = no
   fruit:posix_rename = yes
   fruit:zero_file_id = yes
   fruit:nfs_aces = no
   fruit:wipe_intentionally_left_blank_rfork = yes
   fruit:delete_empty_adfiles = yes

EOF

testparm -s
