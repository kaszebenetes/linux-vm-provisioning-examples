#!/bin/bash

# Debug
# set -x

set -euo pipefail

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
    yum -y install haproxy
fi

echo "
global
        log 127.0.0.1   local0
        log 127.0.0.1   local1 debug
        maxconn   45000 # Total Max Connections.
        daemon
        nbproc      1 # Number of processing cores.
defaults
        timeout server 86400000
        timeout connect 86400000
        timeout client 86400000
        timeout queue   1000s

# [HTTP Site Configuration]
listen http_web 10.0.0.11:80
        mode tcp
        server web-1 10.0.0.21:80 weight 1 maxconn 512 check
        server web-2 10.0.0.22:80 weight 1 maxconn 512 check
" > /tmp/haproxy.cfg

echo
echo "==> Info: Checking haproxy config"
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
echo "==> Info: Checking if haproxy service is running"
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
echo "==> Info: Printing haproxy.service status"
systemctl status haproxy.service
