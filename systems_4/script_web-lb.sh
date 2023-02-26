#!/bin/bash

set -euo pipefail
if [ $(sudo find . /etc/ | grep haproxy) -eq 0 ]
then
    echo "Installing haproxy service:"
    yum -y install haproxy
else
    echo "Haproxy service is already installed."

fi
rm -f /etc/haproxy/haproxy.cfg
echo "
global
   log /dev/log local0
   log /dev/log local1 notice
   chroot /var/lib/haproxy
   stats timeout 30s
   user haproxy
   group haproxy
   daemon

defaults
   log global
   mode tcp
   option httplog
   option dontlognull
   timeout connect 5000
   timeout client 50000
   timeout server 50000

frontend http_front
   bind *:80
   stats uri /haproxy?stats
   default_backend http_back

backend http_back
   balance roundrobin
   server web-1 10.0.0.21:80 check
   server web-2 10.0.0.22:80 check
" > /etc/haproxy/haproxy.cfg
STATUS="$(systemctl is-active haproxy.service)"
if ["${STATUS}" = "inactive"] then {
    echo"Starting haproxy sevice:"
    systemctl start haproxy.service
    systemctl enable haproxy.service
}
else {
    echo "Haproxy was active. Restarting service:"
    systemctl restart haproxy.service
    systemctl status haproxy.service
}