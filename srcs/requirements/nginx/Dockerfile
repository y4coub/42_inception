FROM debian:bookworm

RUN apt-get update && apt-get install -y \
	nginx openssl curl vim \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl \
	&& openssl req -x509 -nodes \
	-subj "/C=MO/ST=MAR/L=BG/O=42/OU=42/CN=yaharkat.42.fr" \
	-out /etc/nginx/ssl/inception.crt \
	-keyout /etc/nginx/ssl/inception.key

COPY conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

WORKDIR /var/www/inception

CMD ["nginx", "-g", "daemon off;"]