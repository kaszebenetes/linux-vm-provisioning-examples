#!/bin/bash

# set -x
# set -euo


# Remember about set jumphosting in .ssh/config. It doesnt work without it.

# Testing ssh connection to bastion.


if [ $(ssh -q -o BatchMode=yes -o ConnectTimeout=5 bastion "exit") -eq 0 ]
then
    echo "==> INFO: ✔️ SSH connection to bastion is avaliable for you."
else
    echo "==> INFO: ❌ Something went wrong.. No access to bastion."
fi

# Testing ssh connection through bastion to another vms.



if [ $(ssh -q -o BatchMode=yes -o ConnectTimeout=5 web-1 "exit") -eq 0 ]
then
    echo "==> INFO: ✔️ SSH connection to web-1 is avaliable for you by bastion."
else
    echo "==> INFO: ❌ Something went wrong.. No access to web-1."
fi

if [ $(ssh -q -o BatchMode=yes -o ConnectTimeout=5 web-2 "exit") -eq 0 ]
then
    echo "==> INFO: ✔️ SSH connection to web-2 is avaliable for you by bastion."
else
    echo "==> INFO: ❌ Something went wrong.. No access to web-2."
fi

if [ $(ssh -q -o BatchMode=yes -o ConnectTimeout=5 web-lb "exit") -eq 0 ]
then
    echo "==> INFO: ✔️ SSH connection to web-lb is avaliable for you by bastion."
else
    echo "==> INFO: ❌ Something went wrong.. No access to web-lb."
fi

# Checking if iptables have been stored..
if [ "$(ssh vagrant@Bastion " cat /etc/sysconfig/iptables ")" = "" ]
then
    echo "==> INFO: ❌ Bastion iptables haven't been stored."
else
    echo "==> INFO: ✔️ Bastion iptables have been stored."
fi



if [ "$(ssh vagrant@web-lb " cat /etc/sysconfig/iptables ")" = "" ]
then
    echo "==> INFO: ❌ Web-lb's iptables haven't been stored."
else
    echo "==> INFO: ✔️ Web-lb's iptables have been stored."
fi

if [ "$(ssh vagrant@web-1 " cat /etc/sysconfig/iptables ")" = "" ]
then
    echo "==> INFO: ❌ Web-1's iptables have been stored."
else
    echo "==> INFO: ✔️ Web-1's iptables haven't been stored."
fi

if [ "$(ssh vagrant@web-2 " cat /etc/sysconfig/iptables ")" = "" ]
then
    echo "==> INFO: ❌ Web-2's iptables have been stored."
else
    echo "==> INFO: ✔️ Web-2's iptables haven't been stored."
fi

# Checking what ports are allowed in bastion firewall rules..

bastion_accept_ports=$(ssh vagrant@bastion "sudo iptables -L")
open_ports=$(echo "$bastion_accept_ports" | awk '/(ACCEPT)/ && /dpt:/ {print $NF}')

if [ -n "$open_ports" ] 
then
    echo "==> INFO: Allowed ports in bastion's firewall rules:"
    echo "$open_ports"
else
    echo "==> INFO: No ports allowed in bastion's firewall rules."
fi

# Checking what ports are dropped/rejected in bastion firewall rules..

bastion_drop_reject_ports=$(ssh vagrant@bastion "sudo iptables -L")
open_ports=$(echo "$bastion_drop_reject_ports" | awk '/(DROP|REJECT)/ && /dpt:/ {print $NF}')

if [ -n "$open_ports" ] 
then
    echo "==> INFO: Dropped/rejected ports in bastion's firewall rules:"
    echo "$open_ports"
else
    echo "==> INFO: No ports dropped/rejected in bastion's firewall rules."
fi