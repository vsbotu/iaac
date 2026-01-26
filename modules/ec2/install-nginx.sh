#!/bin/bash
set -e

# Log output for debugging
exec > /var/log/user-data.log 2>&1

apt-get update -y
apt-get install -y nginx

systemctl start nginx
systemctl enable nginx

echo "Nginx installed successfully"
