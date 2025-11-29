FROM debian:bookworm

RUN apt-get update && \
	apt-get install -y curl bash && \
	rm -rf /var/lib/apt/lists/*

RUN curl -Ss https://get.netdata.cloud/kickstart.sh -o /tmp/kickstart.sh && \
	bash /tmp/kickstart.sh --non-interactive --stable-channel --disable-telemetry && \
	rm /tmp/kickstart.sh

EXPOSE 19999

CMD ["/usr/sbin/netdata", "-D"]