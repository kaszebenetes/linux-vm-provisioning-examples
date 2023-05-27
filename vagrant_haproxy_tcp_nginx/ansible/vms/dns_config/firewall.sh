#!/bin/bash#!/bin/bash

set -x
# set -euo pipefail

if yum list installed | grep -q iptables
then
    echo "==> Info: Iptables service is already installed."
else
    
    echo "==> Info: Installing Iptables service:"
    echo "==> Info: Before installing Iptables , Firewalld is gonna to be disabled..."
        systemctl stop firewalld
        systemctl disable firewalld
        systemctl mask firewalld
    yum -y install iptables-services
    echo "==> Info: Starting Iptables services..."
        systemctl start iptables.service
        systemctl enable iptables.service
fi
