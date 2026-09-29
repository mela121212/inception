#!/bin/bash

set -e

echo "Starting NGINX setup..."

mkdir -p /etc/nginx/ssl

if [ ! -f /etc/nginx/ssl/inception.crt ] || \
   [ ! -f /etc/nginx/ssl/inception.key ]; then

    echo "Generating self-signed SSL certificate..."

    openssl req -x509 \
        -nodes \
        -days 365 \
        -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/inception.key \
        -out /etc/nginx/ssl/inception.crt \
        -subj "/C=ES/ST=Madrid/L=Madrid/O=42/OU=Inception/CN=carmelag.42.fr"
fi

echo "Testing NGINX configuration..."

nginx -t

echo "Starting NGINX..."

exec nginx -g "daemon off;"