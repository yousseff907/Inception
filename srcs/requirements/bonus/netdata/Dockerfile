FROM debian:bookworm

RUN apt-get update && \
	apt-get install -y netdata && \
	rm -rf /var/lib/apt/lists/*

EXPOSE 19999

COPY conf/netdata.conf /etc/netdata/netdata.conf

RUN mkdir -p /var/cache/netdata /var/lib/netdata /var/log/netdata && \
	chown -R netdata:netdata /var/cache/netdata /var/lib/netdata /var/log/netdata

CMD ["/usr/sbin/netdata", "-D"]