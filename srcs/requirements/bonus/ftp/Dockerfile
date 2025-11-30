FROM debian:bookworm

RUN apt-get update && \
	apt-get install -y \
	vsftpd

COPY conf/ftp.conf /etc/vsftpd.conf

EXPOSE 21 21000-21010

ENTRYPOINT ["tools/init-ftp.sh"]