#!/bin/bash

set -euo pipefail

# Install deps
yum install -y vim net-tools

# Enable password auth
sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
systemctl restart sshd
