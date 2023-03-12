#!/bin/bash

set -x
set -euo pipefail

###Vars

NGINX_CONFIG_PATH=/etc/nginx/nginx.conf

NGINX_CONFIG_PATH_CHECK=$(sha256sum $NGINX_CONFIG_PATH)

NAME_OF_MACHINE=$(cat /etc/hostname)

STATUS=$(systemctl is-active nginx.service; exit 0)

LIST=${sudo yum list installed | grep nginx}
###

if [ yum repolist | grep -q 'epel-release';exit 0 ] 
then
    echo "Repository epel is already installed."
else
    echo "Installing repository epel:"
    sudo yum -y install epel-release
fi


yum makecache

if [ "${LIST}" = Null ] 
then
    echo "Installing nginx service:"
    sudo yum -y install nginx
else
    echo "Nginx service is already installed."

fi

mv $NGINX_CONFIG_PATH $TMP_NGINX_CONFIG_PATH

TMP_NGINX_CONFIG_PATH=/tmp/nginx.conf

TMP_NGINX_CONFIG_PATH_CHECK=$(sha256sum /tmp/nginx.conf)

# if [ "${STATUS}" != "active" ] 
# then 
#     echo"Nginx was inactive. Starting ..."
#     systemctl start nginx.service
#     systemctl enable nginx.service
# elif [ "${STATUS}" = "active" && $NGINX_CONFIG_PATH_CHECK =! $TMP_NGINX_CONFIG_PATH_CHECK ]
#     echo "Nginx config file was changed. Needed restart of this service. Proceeding.."
#     systemctl restart nginx.service
# else
    
# fi

systemctl status nginx.service

rm -rf /usr/share/nginx/html/index.html
echo "<body><h1>$NAME_OF_MACHINE</h1></body>" >> /usr/share/nginx/html/index.html

