#!/bin/bash

# install p7zip
sudo amazon-linux-extras install epel
sudo yum install p7zip -y
sudo cp /usr/bin/7za /usr/bin/7z

# install sysbench
sudo yum -y install sysbench

# install ioping
sudo yum install ioping -y
sudo mkdir -p /tmp/ram
sudo mount -t tmpfs -o size=512M tmpfs /tmp/ram/

exit 0

