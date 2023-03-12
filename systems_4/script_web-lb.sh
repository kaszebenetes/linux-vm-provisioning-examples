#!/bin/bash

# set -x
set -euo pipefail

# set -e 

### vars

HAPROXY_CONFIG_PATH=/etc/haproxy/haproxy.cfg
TEMP_HAPROXY_CONFIG_PATH=/tmp/haproxy.cfg
###

echo "==> Info: Checking if haproxy is installed"
if yum list installed | grep -q 'haproxy'
then
    echo "Haproxy package is already installed, proceeding..."
else
    echo "Installing haproxy service:"
    sudo yum -y install haproxy
fi

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
" > /tmp/haproxy.cfg


if [ -f $HAPROXY_CONFIG_PATH ]
then
    echo "Haproxy config exists, proceeding..."
    
    TEMP_HAPROXY_CONFIG_CHECKSUM=$(sha256sum $TEMP_HAPROXY_CONFIG_PATH | awk '{print $1}')
    echo "TEMP_HAPROXY_CONFIG_CHECKSUM=$TEMP_HAPROXY_CONFIG_CHECKSUM"

    HAPROXY_CONFIG_CHECKSUM=$(sha256sum $HAPROXY_CONFIG_PATH | awk '{print $1}')
    echo "HAPROXY_CONFIG_CHECKSUM=$HAPROXY_CONFIG_CHECKSUM"

    if [ "$TEMP_HAPROXY_CONFIG_CHECKSUM" != "$HAPROXY_CONFIG_CHECKSUM" ]
    then
        echo "Checksum differs, overriding config file!"
        mv $TEMP_HAPROXY_CONFIG_PATH $HAPROXY_CONFIG_PATH

        HAPROXY_CONFIG_CHANGED_FLAG=true
    else
        echo "Checksum is the same, haproxy config file not modified"

        HAPROXY_CONFIG_CHANGED_FLAG=false
    fi
else
    echo "Haproxy config file doesn't exist, creating..."
    mv $TEMP_HAPROXY_CONFIG_PATH $HAPROXY_CONFIG_PATH
fi

echo
echo "Checking if haproxy service is running"
# systemctl is-active return exit code 3 if service is not active
STATUS="$(systemctl is-active haproxy.service; exit 0)"
if [[ $STATUS != "active" ]]
then 
    echo "Starting haproxy sevice:"
    systemctl start haproxy.service
    systemctl enable haproxy.service
fi

if [ $HAPROXY_CONFIG_CHANGED_FLAG == true ]
then
    echo "Restarting haproxy.service as config has changed!"
    systemctl restart haproxy.service
else
    echo "Restart not needed, proceeding..."
fi

echo
echo "Printing haproxy.service status"
systemctl status haproxy.service