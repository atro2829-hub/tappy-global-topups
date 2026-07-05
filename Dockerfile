FROM php:8.3-apache

# ── System libraries ──────────────────────────────────────────
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libpq-dev \
    libicu-dev \
    libmysqlclient-dev \
    unzip \
    curl \
    && rm -rf /var/lib/apt/lists/*

# ── PHP extensions (each in its own layer for reliability) ────
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd

RUN docker-php-ext-install zip

RUN docker-php-ext-install pdo_mysql

RUN docker-php-ext-install pdo_pgsql

RUN docker-php-ext-install bcmath

RUN docker-php-ext-install intl

# ── Apache config ─────────────────────────────────────────────
RUN a2enmod rewrite
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# ── App files ─────────────────────────────────────────────────
COPY . /var/www/html
WORKDIR /var/www/html

RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html/storage \
    && chmod -R 775 /var/www/html/bootstrap/cache

# ── Startup ───────────────────────────────────────────────────
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 80

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]