import testinfra
import unittest
# Run script with "--hosts=*server*" argument.

def test_ssh_bastion(host):
    bastion=host.addr("10.0.0.111")
    bastion.port(22).is_reachable
    bastion.port(80).is_reachable
    
def test_ssh_pf_bastion_to_web1(host):
    web1=host.addr("10.0.0.111")
    web1.port(22).is_reachable
    web1.port(80).is_reachable