!/bin/bash
sudo -i
yum -y install haproxy
cd /etc/haproxy/
rm haproxy.cfg
touch haproxy.cfg
echo "
# comment out all for existing [frontend ***] [backend ***] sections
# and add follows to the end
# define frontend ( any name is OK zfor [http-in] )
frontend http-in
    # listen 80 port
    bind *:80
    # set default backend
    default_backend    backend_servers
    # send X-Forwarded-For header
    option             forwardfor

# define backend
backend backend_servers
    # balance with roundrobin
    balance            roundrobin
    # define backend servers
    server             web-1 10.0.0.2:8080 check
    server             web-2 10.0.0.3:8080 check
" -> haproxy.cfg
systemctl enable --now haproxy
