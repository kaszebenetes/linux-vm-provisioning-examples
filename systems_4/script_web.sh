#!/bin/bash

set -euo pipefail
REPOLIST=$(yum repolist -q | grep epel-release)
if ${REPOLIST}; then
    echo "Installing repository epel:"
    sudo yum -y install epel-release
else
    echo "Repository epel is already installed."
fi
yum makecache
LIST=${sudo yum list installed | grep nginx}
if [ "${LIST}" = Null ]; then
    echo "Installing nginx service:"
    sudo yum -y install nginx
else
    echo "Nginx service is already installed."

fi
NGINX_CONFIG_STATUS=$(sha256sum /etc/nginx/nginx.conf)
OLD_NGINX_CONFIG_STATUS="38e3821e3cee16c619b0dc5ac0a76d50c0630b09f592c5251aa747abf7bfb537  nginx.conf"
rm -rf /usr/share/nginx/html/index.html
echo "<body><h1>serwer1</h1></body>" >> /usr/share/nginx/html/index.html
STATUS=$(systemctl is-active nginx.service)
if [ "${STATUS}" = "inactive" ]; then 
    echo"Starting nginx sevice:"
    systemctl start nginx.service
    systemctl enable nginx.service

elif [ "${NGINX_CONFIG_STATUS}" != "${OLD_NGINX_CONFIG_STATUS}" ]; then
    echo "Nginx configuration file has been changed. Restarting service:"
    systemctl restart nginx.service
    systemctl status nginx.service
 else 
    echo "Nginx is active and everything is up to date."
fi