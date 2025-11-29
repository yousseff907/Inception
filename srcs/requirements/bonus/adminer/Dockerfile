FROM debian:bookworm

RUN apt-get update && \
	apt-get install -y \
	php-fpm \
    php-mysqli \
    php-gd \
	wget \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/html && \
	wget "https://www.adminer.org/latest.php" -O /var/www/html/index.php && \
	chown -R www-data:www-data /var/www/html

EXPOSE 9000

CMD ["php-fpm8.2", "-F"]