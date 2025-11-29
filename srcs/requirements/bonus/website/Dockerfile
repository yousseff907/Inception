FROM debian:bookworm

RUN apt-get update && \
	apt-get install -y nginx && \
	rm -rf /var/lib/apt/lists/*

COPY static-website.html /var/www/html/index.html

CMD ["nginx", "-g", "daemon off;"]