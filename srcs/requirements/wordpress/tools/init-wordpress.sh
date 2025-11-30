#!/bin/bash

echo "Waiting for Mariadb..."
while ! mysqladmin ping -h "mariadb" --silent; do
	echo "Mariadb est endormis"
	sleep 2
done
echo "Mariadb is ready"

if [ ! -f /var/www/html/index.php ]; then
    echo "Copying WordPress files..."
    cp -r /usr/src/wordpress/* /var/www/html/
    chown -R www-data:www-data /var/www/html
fi

echo "Creating WordPress configuration..."
wp config create \
	--dbname="${MYSQL_DATABASE}" \
	--dbuser="${MYSQL_USER}" \
	--dbpass="${MYSQL_PASSWORD}" \
	--dbhost="mariadb" \
	--allow-root

wp config set WP_REDIS_HOST 'redis-cache' --allow-root
wp config set WP_REDIS_PORT 6379  --raw --allow-root

echo "Installing WordPress"
wp core install \
	--url="${DOMAIN_NAME}" \
	--title="Inception WordPress" \
	--admin_user="${WP_ADMIN_USER}" \
	--admin_password="${WP_ADMIN_PASSWORD}" \
	--admin_email="${WP_ADMIN_EMAIL}" \
	--allow-root
echo "WordPress setup complete"

echo "Creating second WordPress user..."
wp user create ${WP_USER} ${WP_USER_EMAIL} \
	--user_pass=${WP_USER_PASSWORD} \
	--role=editor \
	--allow-root

echo "Installing Redis plugin..."
wp plugin install redis-cache --activate --allow-root
wp redis enable --allow-root

echo "Starting PHP_FPM..."
exec php-fpm8.2 -F