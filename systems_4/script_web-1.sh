#!/bin/bash

set -euo pipefail
if [ $(yum repolist | grep epel-release) -eq 0 ]
then
    echo "Installing repository epel:"
    yum -y install epel-release
    yum makecache
else
    echo "Repository epel is already installed."
fi
if [ $(sudo find . /etc/ | grep nginx) -eq 0 ]
then
    echo "Installing nginx service:"
    yum -y install nginx
else
    echo "Nginx service is already installed."

fi
rm -f /usr/share/nginx/html/index.html
echo "<body><h1>serwer1</h1></body>" > /usr/share/nginx/html/index.html
STATUS="$(systemctl is-active nginx.service)"
if ["${STATUS}" = "inactive"] then {
    echo"Starting nginx sevice:"
    systemctl start nginx.service
    systemctl enable nginx.service
}
else {
    echo "Nginx was active. Restarting service:"
    systemctl restart nginx.service
    systemctl status nginx.service
}