#!/bin/bash

# set -x
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

##Vars

NAME_OF_MACHINE=$(cat /etc/hostname)

##

if [ "$NAME_OF_MACHINE" = "web-1" ] || [ "$NAME_OF_MACHINE" = "web-2" ] 
then
    echo "Setting up firewall rules.."
    iptables -A INPUT -p tcp -s 10.0.0.11 -j ACCEPT
    iptables -A INPUT -j DROP


elif [ "$NAME_OF_MACHINE" = "web-lb" ]
then
    echo "Setting up firewall rules.."
    iptables -A INPUT -p tcp -s 10.0.0.111 -j ACCEPT
    iptables -A INPUT -j DROP

elif [ "$NAME_OF_MACHINE" = "bastion" ]
then
    echo "Setting up firewall rules.."
    iptables -A INPUT -j ACCEPT
fi