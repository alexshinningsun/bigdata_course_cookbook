#!/bin/bash
sudo amazon-linux-extras install epel
sudo yum install p7zip -y
sudo cp /usr/bin/7za /usr/bin/7z
sudo yum -y install sysbench
exit 0

