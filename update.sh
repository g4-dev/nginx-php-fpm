rm -rf /usr/share/nginx/html/*
git clone git@github.com:g4-dev/src-ecs.git /usr/share/nginx/html \
cd /usr/share/nginx/html && git reset --hard origin/master
cd www/
composer install