FROM debian:bookworm

RUN	apt update && \
	apt install -y --no-install-recommends --no-install-suggests \
	mariadb-server && \
	rm -rf /var/lib/apt/lists/*
 
EXPOSE 3306

COPY	conf/50-server.cnf /etc/mysql/mariadb.conf.d/
COPY	tools/setup.sh /bin/setup.sh

RUN chmod +x /bin/setup.sh

CMD ["setup.sh", "mysqld_safe"]