#!/bin/bash

# set -x
# set -euo pipefail

###Vars

NAME_OF_MACHINE=$(cat /etc/hostname)

###

if yum repolist | grep -q epel
then
    echo "==> Info: Repository epel is already installed."
else
    echo "==> Info: Installing repository epel:"
    sudo yum -y install epel-release
fi


yum makecache

if yum list installed | grep -q nginx
then
    echo "==> Info: Nginx service is already installed."
else

    echo "==> Info: Installing Nginx service:"
    sudo yum -y install nginx
fi

STATUS=$(systemctl is-active nginx.service; exit 0)

if [ "${STATUS}" = "active" ]
then
    echo "==> Info: Nginx service is working..."
else
    echo "==> Info: Nginx was inactive. Starting service..."
    systemctl start nginx.service
    systemctl enable nginx.service
fi

echo
echo "==> Info: Nginx.service status:"
systemctl status nginx.service
echo "<=="
echo

###Interior index.html file:
echo "<body><h1>$NAME_OF_MACHINE</h1></body>" > /tmp/index.html
###

###VarsNGINX

TMP_INDEX_PATH=/tmp/index.html
INDEX_PATH=/usr/share/nginx/html/index.html
CHECK_INDEX=$(sha256sum /usr/share/nginx/html/index.html | awk '{print $1}')
TMP_CHECK_INDEX=$(sha256sum /tmp/index.html | awk '{print $1}')
###

if [ -f $INDEX_PATH ] && [ "$CHECK_INDEX" = "$TMP_CHECK_INDEX" ]
then
    echo "==> Info: Index.html file exists. No differs in file."
elif [ -f $INDEX_PATH ] && [ "$CHECK_INDEX" != "$TMP_CHECK_INDEX" ]
then
    echo "==> Info: File Index.html has changed. Reloading service..."
    mv $TMP_INDEX_PATH $INDEX_PATH
    systemctl reload nginx
else
    echo "==> Info: Index.html doesnt exists. Inserting file..."
    mv $TMP_INDEX_PATH $INDEX_PATH
fi
