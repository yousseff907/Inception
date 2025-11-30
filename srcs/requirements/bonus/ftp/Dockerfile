FROM debian:bookworm

RUN apt-get update && \
	apt-get install -y vsftpd && \
	rm -rf /var/lib/apt/lists/*

COPY conf/ftp.conf /etc/vsftpd.conf
COPY tools/init-ftp.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/init-ftp.sh

EXPOSE 21 21000-21010

ENTRYPOINT ["/usr/local/bin/init-ftp.sh"]