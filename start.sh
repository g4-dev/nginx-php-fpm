#!/bin/bash

# Update nginx to match worker_processes to no. of cpu's
procs=$(cat /proc/cpuinfo |grep processor | wc -l)
sed -i -e "s/worker_processes 1;/worker_processes $procs;/" /etc/nginx/nginx.conf

# Start supervisord and services
/usr/local/bin/supervisord -n -c /etc/supervisord.conf

cd /usr/share/nginx/html/
rm -rf *
git init && git remote add origin git@github.com:g4-dev/src-ecs.git

touch update.php && chmod 111 update.php
echo "<?php `git fetch --all && git reset --hard origin master;
        composer -d ./www install -n;
        php www/bin/console doctrine:schema:update -f -n;
        chown -Rf nginx.nginx /usr/share/nginx/html;` ?>" >> update.php
php -r update.php
