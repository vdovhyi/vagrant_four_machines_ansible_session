#!/bin/bash

# BEGIN ########################################################################
echo -e "-- ------------------------------ --\n"
echo -e "-- BEGIN ANSIBLE MASTER & HAPROXY --\n"
echo -e "-- ------------------------------ --\n"

# BOX ##########################################################################
echo -e "-- Updating packages list\n"
sudo yum update -y

# Install Packages #############################################################
echo -e "-- Install Packages\n"
pckarr=(mc nano ansible nmap) 
for i in ${pckarr[*]}; do 
  isinstalled=$(rpm -q $i) 
  if [ ! "$isinstalled" == "package $i is not installed" ]; 
    then echo "Package $i already installed"
  else echo "Install $i" 
  sudo yum install $i -y 
  fi 
done

echo -e "-- Copy ansible files to ansible_master\n"
sudo cp /vagrant/ansible /home/vagrant/ansible

sudo setenforce 0

# HAPROXY ######################################################################
echo -e "-- Installing HAProxy\n"
sudo yum install -y haproxy > /dev/null 2>&1
sudo systemctl enable haproxy
sudo systemctl start haproxy

echo -e "-- Configuring HAProxy\n"
sudo mv /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.old
cat <<EOF | sudo tee -a /etc/haproxy/haproxy.cfg
global
    log /dev/log local0
    log localhost local1 notice
    user haproxy
    group haproxy
    maxconn 2000
    daemon
 
defaults
    log global
    mode http
    option httplog
    option dontlognull
    retries 3
    timeout connect 5000
    timeout client 50000
    timeout server 50000
 
frontend http-in
    bind *:80
    mode http
    default_backend webservers

backend webservers
    balance roundrobin

    mode http
    option httpchk
    option forwardfor
    cookie SRVNAME insert
    option http-keep-alive
    server machine1 192.168.56.21:80 cookie machine1 check
    server machine2 192.168.56.22:80 cookie machine2 check

listen stats *:1936
    stats enable
    stats uri /
    stats hide-version
    stats auth admin:admin
EOF

echo -e "-- Validating HAProxy configuration\n"
haproxy -f /etc/haproxy/haproxy.cfg -c

echo -e "-- Restarting HAProxy\n"
sudo systemctl restart haproxy

