#!/bin/bash

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

FILE=/var/www/wordpress/wp-config.php 
if [ ! -f "$FILE" ]; then
	mkdir -p /var/www/wordpress
	wp cli update
   	wp core download --allow-root --path='/var/www/wordpress'
	wp core config \
		--allow-root \
		--dbname=$DB_NAME \
		--dbuser=$DB_LOGIN \
		--dbpass=$DB_PASS \
		--dbhost=mariadb:3306 \
		--path='/var/www/wordpress'

	wp core install \
		--allow-root \
		--url=$DOMAIN \
		--title=$WP_TITLE \
		--admin_user=$WP_ADMIN \
		--admin_password=$WP_ADMINPASS \
		--admin_email="kyukim@student.42seoul.kr" \
		--skip-email \
		--path='/var/www/wordpress'

	wp user create \
		--allow-root \
		$WP_USER \
		irrelevant@email.com \
		--user_pass=$WP_USERPASS \
		--role=author
fi
php-fpm7.3 --nodaemonize

mv www.conf etc/php/7.3/fpm/pool.d/
chown -R www-data:www-data /var/www/wordpress
php-fpm7.3
