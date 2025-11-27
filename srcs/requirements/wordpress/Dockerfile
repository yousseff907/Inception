FROM debian:bookworm

RUN apt-get update && \
	apt-get install -y \
    php-fpm \
    php-mysqli \
    php-gd \
    php-curl \
    php-xml \
	curl \
	unzip \
	mariadb-client && \
	rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/html && \
	curl -LO https://wordpress.org/latest.zip && \
	unzip latest.zip && \
	rm latest.zip && \
	mv wordpress/* /var/www/html/ && \
	rmdir wordpress/

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/local/bin/wp

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY tools/init-wordpress.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init-wordpress.sh

WORKDIR /var/www/html/

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/init-wordpress.sh"]