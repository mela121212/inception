#!/bin/bash

set -e

echo "Starting WordPress setup..."

: "${MYSQL_HOST:?MYSQL_HOST is not defined}"
: "${MYSQL_DATABASE:?MYSQL_DATABASE is not defined}"
: "${MYSQL_USER:?MYSQL_USER is not defined}"
: "${DOMAIN_NAME:?DOMAIN_NAME is not defined}"
: "${WP_TITLE:?WP_TITLE is not defined}"
: "${WP_ADMIN_USER:?WP_ADMIN_USER is not defined}"
: "${WP_ADMIN_EMAIL:?WP_ADMIN_EMAIL is not defined}"
: "${WP_USER:?WP_USER is not defined}"
: "${WP_USER_EMAIL:?WP_USER_EMAIL is not defined}"

DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

mkdir -p /var/www/html
cd /var/www/html

echo "Waiting for MariaDB..."

until mysqladmin ping \
    -h"${MYSQL_HOST}" \
    -P3306 \
    -u"${MYSQL_USER}" \
    --password="${DB_PASSWORD}" \
    --silent
do
    echo "MariaDB is unavailable. Waiting..."
    sleep 2
done

echo "MariaDB is ready."

if [ ! -f /var/www/html/wp-load.php ]; then
    echo "Downloading WordPress..."

    curl -fsSL https://wordpress.org/latest.tar.gz -o /tmp/wordpress.tar.gz
    tar -xzf /tmp/wordpress.tar.gz \
        --strip-components=1 \
        -C /var/www/html

    rm -f /tmp/wordpress.tar.gz
fi

if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Creating wp-config.php..."

    wp config create \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${DB_PASSWORD}" \
        --dbhost="${MYSQL_HOST}:3306" \
        --allow-root \
        --path=/var/www/html

    echo "Installing WordPress..."

    wp core install \
        --url="https://${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --allow-root \
        --path=/var/www/html

    echo "Creating normal WordPress user..."

    wp user create \
        "${WP_USER}" \
        "${WP_USER_EMAIL}" \
        --user_pass="${WP_USER_PASSWORD}" \
        --role=author \
        --allow-root \
        --path=/var/www/html
else
    echo "WordPress is already configured."
fi

chown -R www-data:www-data /var/www/html

echo "Starting PHP-FPM..."

sed -i 's/^listen = .*/listen = 9000/' \
    /etc/php/8.2/fpm/pool.d/www.conf

exec php-fpm8.2 -F