#!/bin/bash


# Vars:
# SSH commands to vms..
sshtobastion=$(ssh -L vagrant@10.0.0.111)

sshbastiontoweblb=$(ssh -R 22:10.0.0.11:8080 vagrant@10.0.0.111 | cat %errorlevel%)
sshbastiontoweblb=$(ssh -R 22:10.0.0.11:8080 vagrant@10.0.0.111 | cat %errorlevel%)

sshbastiontoweb1=$(ssh -R 22:10.0.0.21:8080 vagrant@10.0.0.111 | cat %errorlevel%)

sshbastiontoweb2=$(ssh -R 22:10.0.0.22:8080 vagrant@10.0.0.111 | cat %errorlevel%)
#

# Checking if iptables have been saved..
iptablesbastion=$(ssh -R vagrant@10.0.0.111 | -f /etc/sysconfig/iptables)

iptablesweb1=$(ssh -R 22:10.0.0.21:22 vagrant@10.0.0.111)

iptablesweb2=$(ssh -R 22:10.0.0.22:22 vagrant@10.0.0.111)


iptables=$(ssh -R vagrant@10.0.0.111 | iptables -L)
# Testing ssh connection to bastion.
if [ "$sshtobastion" != "0" ]
then
    echo "==> INFO: SSH connection to bastion is avaliable for you."
else
    echo "==> INFO: Something went wrong.. No access to bastion."
fi

# Testing ssh connection through bastion to another vms.
if [ "$sshbastiontoweb1" != "0" ]
then
    echo "==> INFO: SSH connection to web1 is avaliable for you by bastion."
else
    echo "==> INFO: Something went wrong.. No access to web-1."
fi
    

if [ "$sshbastiontoweb2" != "0" ]
then
    echo "==> INFO: SSH connection to web2 is avaliable for you by bastion."
else
    echo "==> INFO: Something went wrong.. No access to web-2."
fi

if [ "$sshbastiontoweblb" != "0" ]
then
    echo "==> INFO: SSH connection to weblb is avaliable for you by bastion."
else
    echo "==> INFO: Something went wrong.. No access to web-lb."
fi
    
if [ "$iptablesbastion" ] && [ -f /etc/sysconfig/iptables ]
then
    echo "==> INFO: Bastion iptables have been stored."
else
    echo "==> INFO: Bastion iptables haven't been stored."
fi

if [ "$iptablesweblb" ] && [ -f /etc/sysconfig/iptables ]
then
    echo "==> INFO: Web-lb's iptables have been stored."
else
    echo "==> INFO: Web-lb's iptables haven't been stored."
fi

if [ "$iptablesweb1" ] && [ -f /etc/sysconfig/iptables ]
then
    echo "==> INFO: Web-1's iptables have been stored."
else
    echo "==> INFO: Web-1's iptables haven't been stored."
fi

if [ "$iptablesweb2" ] && [ -f /etc/sysconfig/iptables ] 
then
    echo "==> INFO: Web-2's iptables have been stored."
else
    echo "==> INFO: Web-2's iptables haven't been stored."
fi

curl 10.0.0.11
            
        
    
        
    

    
    