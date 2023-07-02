#!/bin/bash

# set -x
# set -euo


# Remember about set jumphosting in .ssh/config. It doesnt work without it.

# Testing ssh connection to bastion.

ssh vagrant@bastion exit 0
if [ $(echo $?) = "0" ]
then
    echo "==> INFO: SSH connection to bastion is avaliable for you."
else
    echo "==> INFO: Something went wrong.. No access to bastion."
fi

# Testing ssh connection through bastion to another vms.

# Vars:
var points = 0
#
ssh vagrant@web-1 exit 0
if [ $(echo $?) = "0" ]
then
    echo "==> INFO: SSH connection to web1 is avaliable for you by bastion."
    points+=1
else
    echo "==> INFO: Something went wrong.. No access to web-1."
fi

ssh vagrant@web-2 exit 0
if [ $(echo $?) = "0" ]
then
    echo "==> INFO: SSH connection to web2 is avaliable for you by bastion."
    points+=1
else
    echo "==> INFO: Something went wrong.. No access to web-2."
fi

ssh vagrant@web-lb exit 0
if [ $(echo $?) = "0" ]
then
    echo "==> INFO: SSH connection to weblb is avaliable for you by bastion."
    points+=1
else
    echo "==> INFO: Something went wrong.. No access to web-lb."
fi

if [ "$(ssh vagrant@Bastion " ls /etc/sysconfig/ | grep 'iptables'")" ]
then
    echo "==> INFO: Bastion iptables have been stored."
    points+=1
else
    echo "==> INFO: Bastion iptables haven't been stored."
fi
echo "In ssh test part u got:$points "


if [ "$(ssh -A -J vagrant@web-lb vagrant@Bastion "ls /etc/sysconfig/ | grep 'iptables'")" ]
then
    echo "==> INFO: web-lb's iptables have been stored."
else
    echo "==> INFO: web-lb's iptables haven't been stored."
fi

if [ "$(ssh -A -J vagrant@Web-lb vagrant@Bastion "ls /etc/sysconfig/ | grep 'iptables'")" ]
then
    echo "==> INFO: Web-1's iptables have been stored."
else
    echo "==> INFO: Web-1's iptables haven't been stored."
fi

if [ "$(ssh -A -J vagrant@Web-lb vagrant@Bastion "ls /etc/sysconfig/ | grep 'iptables'")" ]
then
    echo "==> INFO: Web-2's iptables have been stored."
else
    echo "==> INFO: Web-2's iptables haven't been stored."
fi
