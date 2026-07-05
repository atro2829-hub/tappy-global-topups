#!/bin/bash
set -e
cd /var/www/html

# Fix cross-region DB connection: internal hostname only works in same region
# If DB_HOST looks like an internal Render hostname (dpg-xxx without dots), use external one
if [ -n "$DB_HOST" ] && [[ "$DB_HOST" == dpg-* ]] && [[ "$DB_HOST" != *.* ]]; then
    export DB_HOST="${DB_HOST}.virginia-postgres.render.com"
    echo "Switched DB_HOST to external: $DB_HOST"
fi

# Set APP_URL if not already set
if [ -z "$APP_URL" ]; then
    export APP_URL="https://tappynew.onrender.com"
fi

# Temporary debug - remove after fixing
export APP_DEBUG=true

if [ -z "$APP_KEY" ]; then
    php artisan key:generate --force
fi

php artisan storage:link || true
php artisan config:cache
php artisan route:cache
php artisan view:cache
php artisan migrate --force

exec "$@"