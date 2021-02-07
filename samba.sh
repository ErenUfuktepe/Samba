#!/bin/bash

sudo apt-get update
sudo apt-get install samba

cd /etc/samba

sudo mv smb.conf smb_backup.conf
sudo touch smb.conf

echo "WORKGROUP NAME:"
read workgroup
echo "SHARE FOLDER DIRECTORY:"
read dir
echo "USER:"
read user
echo -e "[global] \n\tworkgroup = $workgroup\n\tserver string  = Samba Server %v\n\tnetbios name = Ubuntu\n\tsecurity = user\n\tmap to guest = bad user\n\tdns proxy = no\n[Share]\n\tpath = $dir\n\tbrowsable = yes\n\twritable = yes\n\tguest ok = yes\n\tread only = no\n\tcreate mask = 0644\n\tdirectory mask = 0755\n\tforce user = $user" | sudo tee -a smb.conf

sudo groupadd $workgroup
sudo useradd $user -s /sbin/nolgin 
sudo smbpasswd -a $user
sudo usermod -aG $workgroup $user

sudo systemctl enable smbd nmbd
sudo systemctl start smbd
sudo systemctl start nmbd

sudo service smbd restart
sudo service nmbd restart

sudo chgrp -R $workgroup $dir