import subprocess


# Repository which is required by loading-bar
tqdm = subprocess.run("yum repolist | grep 'tqdm'")
#

# SSH commands to vms..
sshtobastion = subprocess.run("ssh -L -q vagrant@10.0.0.111")

sshbastiontoweblb = subprocess.run("ssh -R -q 8080:10.0.0.11:22 vagrant@10.0.0.111")

sshbastiontoweb1 = subprocess.run("ssh -R -q 8080:10.0.0.21:22 vagrant@10.0.0.111")

sshbastiontoweb2 = subprocess.run("ssh -R -q 8080:10.0.0.22:22 vagrant@10.0.0.111")
#

# Checking if iptables have been saved..
iptablesbastion = subprocess.run("ssh -L vagrant@10.0.0.111 | /etc/sysconfig/iptables")

iptablesweblb = subprocess.run("ssh -R 22:10.0.0.11:22 vagrant@10.0.0.111 | -f /etc/sysconfig/iptables")

iptablesweb1 = subprocess.run("ssh -R 22:10.0.0.21:22 vagrant@10.0.0.111 | -f /etc/sysconfig/iptables")

iptablesweb2 = subprocess.run("ssh -R 22:10.0.0.22:22 vagrant@10.0.0.111 | -f /etc/sysconfig/iptables")


iptables=subprocess.run("ssh -L vagrant@10.0.0.111 | iptables -L")
