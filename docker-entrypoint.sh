#!/bin/bash
set -e
cd /var/www/html

if [ -z "$APP_KEY" ]; then
    php artisan key:generate --force
fi

php artisan config:cache
php artisan route:cache
php artisan view:cache
php artisan migrate --force

exec "$@"