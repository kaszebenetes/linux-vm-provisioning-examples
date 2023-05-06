#!/usr/bin/env python3 

import constants as c
import subprocess
import os
import time





    
    # Installing repo tqdm for bar
# if c.tqdm :
#         print("Tqdm is already installed.")
# else:
#         print("Installing tqdm repository..")
#         'pip install tqdm'

# pbar = tqdm(total=100)
# for i in range(10):
    # Testing ssh connection to bastion.
if c.sshtobastion != "0" :
    print("SSH connection to bastion is avaliable for you.")
    # pbar.update(10)
else:
    print("Something went wrong.. No access to bastion.")
    # pbar.close()

# Testing ssh connection through bastion to another vms.
if c.sshbastiontoweb1 != "0" :
    print("SSH connection to web1 is avaliable for you.")
    # pbar.update(10)
else:
    print("Something went wrong.. No access to web-1.")
    # pbar.close()
    

if c.sshbastiontoweb2 != "0" :
    print("SSH connection to web2 is avaliable for you.")
    # pbar.update(10)
else:
    print("Something went wrong.. No access to web-2.")
    # pbar.close()

if c.sshbastiontoweblb != "0" :
    print("SSH connection to weblb is avaliable for you.")
    # pbar.update(10)
else:
    print("Something went wrong.. No access to web-lb.")
    # pbar.close()
    
if c.iptablesbastion :
    print("Bastion iptables have been stored.")
    # pbar.update(10)
else:
    print("Bastion iptables haven't been stored.")
    # pbar.close()

if c.iptablesweblb :
    print("Web-lb's iptables have been stored.")
    # pbar.update(10)
else:
    print("Web-lb's iptables haven't been stored.")
    # pbar.close()

if c.iptablesweb1 :
    print("Web-1's iptables have been stored.")
    # pbar.update(10)
else:
    print("Web-1's iptables haven't been stored.")
    # pbar.close()

if c.iptablesweb2 :
    print("Web-2's iptables have been stored.")
    # pbar.update(10)
else:
    print("Web-2's iptables haven't been stored.")
    # pbar.close()
            
        
    
        
    

    
    