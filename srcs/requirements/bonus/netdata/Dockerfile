FROM debian:bookworm

RUN apt-get update && \
	apt-get install -y netdata && \
	rm -rf /var/lib/apt/lists/*

EXPOSE 19999

COPY conf/netdata.conf /etc/netdata/netdata.conf

CMD ["netdata", "-D"]