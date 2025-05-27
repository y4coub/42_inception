FROM debian:bullseye

RUN apt-get update && apt-get install -y --no-install-recommends \
    php php-mysql wget php7.4-fpm php-curl curl netcat-openbsd ca-certificates && \
    update-ca-certificates && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

RUN curl -k -o /tmp/wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /tmp/wp-cli.phar \
    && mv /tmp/wp-cli.phar /usr/local/bin/wp

RUN mkdir -p /run/php /var/www/inception

COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/

COPY ./tools/setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup.sh

WORKDIR /var/www/inception

EXPOSE 9000

ENTRYPOINT ["/bin/bash", "/usr/local/bin/setup.sh"]
CMD ["/usr/sbin/php-fpm7.4", "-F"]