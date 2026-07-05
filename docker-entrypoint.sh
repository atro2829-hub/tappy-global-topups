#!/bin/bash
set -e

cd /var/www/html

# Generate APP_KEY if not set
if [ -z "$APP_KEY" ]; then
    php artisan key:generate --force
fi

# Run migrations
php artisan migrate --force

# Execute the main command
exec "$@"