import subprocess
import os
import time

# Repository which is required by loading-bar
# tqdm = os.system("dnf repolist | grep 'tqdm'")
#

# SSH commands to vms..
sshtobastion = os.system("ssh -L vagrant@10.0.0.111")

sshbastiontoweblb = os.system("ssh -R 22:10.0.0.11:8080 vagrant@10.0.0.111")

sshbastiontoweb1 = os.system("ssh -R 8080:10.0.0.21:22 vagrant@10.0.0.111")

sshbastiontoweb2 = os.system("ssh -R 8080:10.0.0.22:22 vagrant@10.0.0.111")
#

# Checking if iptables have been saved..
iptablesbastion = os.system("ssh -L vagrant@10.0.0.111 | /etc/sysconfig/iptables")

iptablesweblb = os.system("ssh -R 22:10.0.0.11:22 vagrant@10.0.0.111 | -f /etc/sysconfig/iptables")

iptablesweb1 = os.system("ssh -R 22:10.0.0.21:22 vagrant@10.0.0.111 | -f /etc/sysconfig/iptables")

iptablesweb2 = os.system("ssh -R 22:10.0.0.22:22 vagrant@10.0.0.111 | -f /etc/sysconfig/iptables")


iptables=os.system("ssh -L vagrant@10.0.0.111 | iptables -L")
