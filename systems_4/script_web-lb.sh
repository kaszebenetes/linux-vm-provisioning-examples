#!/bin/bash

yum -y install haproxy
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
systemctl enable haproxy
systemctl start haproxy
systemctl restart haproxy
systemctl status haproxy