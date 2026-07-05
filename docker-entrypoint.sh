#!/bin/bash
set -e
cd /var/www/html

# Fix cross-region DB connection: internal hostname only works in same region
# If DB_HOST looks like an internal Render hostname (dpg-xxx without dots), use external one
if [ -n "$DB_HOST" ] && [[ "$DB_HOST" == dpg-* ]] && [[ "$DB_HOST" != *.* ]]; then
    export DB_HOST="${DB_HOST}.virginia-postgres.render.com"
    echo "Switched DB_HOST to external: $DB_HOST"
fi

if [ -z "$APP_KEY" ]; then
    php artisan key:generate --force
fi

php artisan config:cache
php artisan route:cache
php artisan view:cache
php artisan migrate --force

exec "$@"