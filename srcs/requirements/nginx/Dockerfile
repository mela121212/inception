FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y nginx openssl && \
    rm -rf /var/lib/apt/lists/*

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY tools/setup.sh /usr/local/bin/setup.sh

RUN chmod +x /usr/local/bin/setup.sh && \
    rm -f /etc/nginx/sites-enabled/default

EXPOSE 443

ENTRYPOINT ["/usr/local/bin/setup.sh"]
