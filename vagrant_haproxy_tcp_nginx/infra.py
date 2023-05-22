import testinfra
import unittest
import subprocess
# Run script with "--hosts=*server*" argument.

def test_ssh_bastion(host):
    bastion=host.addr("10.0.0.111")
    assert bastion.port(22).is_reachable
    
def test_ssh_pf_bastion_to_web1(host):
    adress=subprocess("ssh -L 22:10.0.0.21:8080 vagrant@10.0.0.111")
    web1=host.addr(ssh://22:10.0.0.21:8080 vagrant@10.0.0.111)
    assert web1.port(22).is_reachable
    assert web1.port(80).is_reachable

def test_ssh_pf_bastion_to_web2(host):
    web2=host.addr("10.0.0.22")
    assert web2.port(22).is_reachable
    assert web2.port(80).is_reachable

def test_ssh_pf_bastion_to_weblb(host):
    weblb=host.addr("10.0.0.11")
    assert weblb.port(22).is_reachable

def iptablesbastion(host):
    bastion=host.addr("10.0.0.111")
    assert host.Iptables.rules()