#!/bin/bash

yum -y install epel-release
yum makecache
yum -y install nginx
rm -f /usr/share/nginx/html/index.html
echo "<body><h1>serwer1</h1></body>" > /usr/share/nginx/html/index.html
systemctl start nginx.service
systemctl enable nginx.service
systemctl restart nginx.service
systemctl status nginx.service