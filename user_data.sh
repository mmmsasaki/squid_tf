#!/bin/bash
yum update -y
yum install squid -y
sed -e "/^http_access deny all/s/^/# /" -i.org /etc/squid/squid.conf
echo "http_access allow all"  >> /etc/squid/squid.conf
service squid start
