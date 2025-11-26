#!/bin/bash

echo "Waiting for Mariadb..."
while ! mysqladmin ping -h "mariadb" --silent; do
	echo "Mariadb est endormis"
	sleep 2
done
echo "Mariadb is ready"

echo "Creating WordPress configuration..."
wp config create \
	--dbname="${MYSQL_DATABASE}" \
	--dbuser="${MYSQL_USER}" \
	--dbpass="${MYSQL_PASSWORD}" \
	--dbhost="mariadb" \
	--allow-root

echo "Installing WordPress"
wp core install \
	--url="${DOMAIN_NAME}" \
	--title="Inception WordPress" \
	--admin_user="${WP_ADMIN_USER}" \
	--admin_password="${WP_ADMIN_PASSWORD}" \
	--admin_email="${WP_ADMIN_EMAIL}" \
	--allow-root
echo "WordPress setup complete"

echo "Starting PHP_FPM..."
exec php-fpm -F