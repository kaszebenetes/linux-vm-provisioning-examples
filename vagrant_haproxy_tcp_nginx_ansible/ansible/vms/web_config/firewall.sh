#!/bin/bash

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

iptables -I OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -I INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -I INPUT -p tcp -s 10.0.0.111 --dport 22 -j ACCEPT
iptables -I INPUT -p tcp -s 10.0.0.11 --dport 80 -j ACCEPT
iptables -I OUTPUT -p tcp --dport 80 -j ACCEPT
iptables -I OUTPUT -p tcp --dport 443 -j ACCEPT
iptables -I OUTPUT -p udp --dport 53 -j ACCEPT
iptables -A INPUT -j DROP
iptables -A OUTPUT -j DROP

sudo bash -c "iptables-save > /etc/sysconfig/iptables"