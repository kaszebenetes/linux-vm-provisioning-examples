#!/bin/bash

# set -x
# set -euo

# Remember about setting up jump host in .ssh/config. It won't work without it.

# Testing SSH connection to bastion.

if ssh -q -o BatchMode=yes -o ConnectTimeout=5 bastion "exit"; then
    echo "==> INFO: ✔️ SSH connection to bastion is available for you."
else
    echo "==> INFO: ❌ Something went wrong.. No access to bastion."
fi

# Testing SSH connection through bastion to other VMs.

test_ssh_connection() {
    vm_name=$1
    if ssh -q -o BatchMode=yes -o ConnectTimeout=5 "bastion" "ssh $vm_name 'exit'"; then
        echo "==> INFO: ✔️ SSH connection to $vm_name is available for you by bastion."
    else
        echo "==> INFO: ❌ Something went wrong.. No access to $vm_name."
    fi
}

test_ssh_connection "web-1"
test_ssh_connection "web-2"
test_ssh_connection "web-lb"

# Checking if iptables have been stored.

check_iptables() {
    vm_name=$1
    if [ -z "$(ssh vagrant@$vm_name 'cat /etc/sysconfig/iptables')" ]; then
        echo "==> INFO: ❌ $vm_name iptables haven't been stored."
    else
        echo "==> INFO: ✔️ $vm_name iptables have been stored."
    fi
}

check_iptables "Bastion"
check_iptables "web-lb"
check_iptables "web-1"
check_iptables "web-2"

# Checking what ports are allowed in bastion firewall rules.

bastion_accept_ports=$(ssh vagrant@bastion "sudo iptables -L")
open_ports=$(echo "$bastion_accept_ports" | awk '/(ACCEPT)/ && /dpt:/ {print $NF}')

if [ -n "$open_ports" ]; then
    echo "==> INFO: Allowed ports in bastion's firewall rules:"
    echo "$open_ports"
else
    echo "==> INFO: No ports allowed in bastion's firewall rules."
fi

# Checking what ports are dropped/rejected in bastion firewall rules.

bastion_drop_reject_ports=$(ssh vagrant@bastion "sudo iptables -L")
closed_ports=$(echo "$bastion_drop_reject_ports" | awk '/(DROP|REJECT)/ && /dpt:/ {print $NF}')

if [ -n "$closed_ports" ]; then
    echo "==> INFO: Dropped/rejected ports in bastion's firewall rules:"
    echo "$closed_ports"
else
    echo "==> INFO: No ports dropped/rejected in bastion's firewall rules."
fi

# Additional tests:

# 5. Does Bastion allow only output on port 22?

bastion_port_22_output=$(ssh vagrant@bastion "sudo iptables -L OUTPUT -n -v | grep 'dpt:22'")
if [ -n "$bastion_port_22_output" ]; then
    echo "==> INFO: Bastion allows only output on port 22."
else
    echo "==> INFO: ❌ Bastion doesnt allow only output on port 22."
fi

# 6. Is access from PC to web1-2 only by web-lb?

pc_to_web_access=$(ssh vagrant@web-lb "sudo iptables -L -n -v | grep 'dpt:22' | grep 'ACCEPT' | grep '0.0.0.0/0'")
if [ -n "$pc_to_web_access" ]; then
    echo "==> INFO: Access from PC to web1-2 is only by web-lb."
else
    echo "==> INFO: ❌ Access from PC to web1-2 is not only by web-lb."
fi
