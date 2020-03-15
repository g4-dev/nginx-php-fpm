#!/bin/bash

# Update nginx to match worker_processes to no. of cpu's
procs=$(cat /proc/cpuinfo |grep processor | wc -l)
sed -i -e "s/worker_processes  1/worker_processes $procs/" /etc/nginx/nginx.conf

# Always chown webroot for better mounting
chown -Rf nginx.nginx /usr/share/nginx/html

# Start supervisord and services
/usr/local/bin/supervisord -n -c /etc/supervisord.conf

rm -rf /usr/share/nginx/html/*
git clone git@github.com:g4-dev/src-ecs.git /usr/share/nginx/html/ \
cd /usr/share/nginx/html && git reset --hard origin/master
touch update.php && chmod +x update.php
echo "<?php `git pull origin master && composer -d ./www install -n` ?>" >> update.php
php -r update.php