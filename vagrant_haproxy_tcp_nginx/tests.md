1.SSH only connects to bastion
2.From bastion to another vms
3.Are iptables rules persistent saved
4.To bastion only port 22 is allowed
5.Bastion allows only output on port 22
6.From PC access to web1-2 is only by web-lb





sudo iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT -> 
iptables -I OUTPUT -p tcp --dport 443 -j ACCEPT -> Allows https connections
iptables -I OUTPUT -p udp --dport 53 -j ACCEPT -> Allows to resolve dns hosts
iptables -I OUTPUT -p tcp --dport 22 -j ACCEPT -> Allows to entry by ssh to another vms
