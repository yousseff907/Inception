FROM debian:bookworm

RUN apt-get update && \
	apt-get install -y \
    php-fpm \
    php-mysqli \
    php-gd \
    php-curl \
    php-xml \
	curl \
	unzip

RUN curl -LO https://wordpress.org/latest.zip && \
	unzip latest.zip && \
	rm latest.zip && \
	mv wordpress/* /var/www/html/ && \
	rmdir wordpress/

COPY source dest

ENTRYPOINT [""]