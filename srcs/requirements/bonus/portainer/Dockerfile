FROM debian:bookworm

RUN apt-get update && \
	apt-get install -y \
	curl \
	ca-certificates && \
	rm -rf /var/lib/apt/lists/*

RUN mkdir -p /portainer && \
	curl -L https://github.com/portainer/portainer/releases/latest/download/portainer-linux-amd64 -o /portainer/portainer && \
	chmod +x /portainer/portainer

RUN mkdir -p /data

EXPOSE 8080

CMD ["/portainer/portainer", "--data", "/data"]
