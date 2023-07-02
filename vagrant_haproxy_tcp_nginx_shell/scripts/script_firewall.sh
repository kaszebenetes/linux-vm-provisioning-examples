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

##Vars

NAME_OF_MACHINE=$(cat /etc/hostname)

##

if [[ "$NAME_OF_MACHINE" == "web-1" ]] || [[ "$NAME_OF_MACHINE" == "web-2" ]]
then
  echo "Setting up web servers firewall rules.."
  iptables -I INPUT -p tcp -s 10.0.0.11 --dport 80 -j ACCEPT
elif [[ "$NAME_OF_MACHINE" == "lb-web" ]]
then
  echo "Setting up lb-web firewall rules.."
  iptables -I INPUT -p tcp --dport 80 -j ACCEPT
  iptables -I INPUT -p tcp --dport 443 -j ACCEPT
elif [[ "$NAME_OF_MACHINE" != "bastion" ]]
then
  echo "Setting up non-bastion firewall rules.."
  iptables -A INPUT -p tcp -s 10.0.0.111 --dport 22 -j ACCEPT
elif [[ "$NAME_OF_MACHINE" == "bastion" ]]
then
  echo "Setting up bastion firewall rules.."
  iptables -I INPUT -p tcp -s 10.0.0.0/24 --dport 22 -j ACCEPT
  iptables -I OUTPUT -p tcp -d 10.0.0.0/24 --dport 22 -j ACCEPT
fi

echo "Setting up generic firewall rules.."

# TODO: Remove when ssh via vagrant through bastion will be fixed
iptables -I INPUT -p tcp -s 192.168.0.0/16 --dport 22 -j ACCEPT

iptables -I OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -I INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -I OUTPUT -p tcp --dport 80 -j ACCEPT
iptables -I OUTPUT -p tcp --dport 443 -j ACCEPT
iptables -I OUTPUT -p udp --dport 53 -j ACCEPT
iptables -A INPUT -j DROP
iptables -A OUTPUT -j DROP

# TODO: Consider loading /etc/sysconfig/iptables file, beacuse if you will flush iptables every single time you run this script, there will be a short period of time when no firewall rules will be defined on a host
iptables-save > /etc/sysconfig/iptables
