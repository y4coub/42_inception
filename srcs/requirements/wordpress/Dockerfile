FROM debian:bookworm

# Install dependencies in a single layer with proper cleanup
RUN apt-get update && apt-get install -y --no-install-recommends \
    php php-mysql wget php8.2-fpm php-curl curl netcat-openbsd ca-certificates && \
    update-ca-certificates && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Install WP-CLI with verification
RUN curl -k -o /tmp/wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /tmp/wp-cli.phar \
    && mv /tmp/wp-cli.phar /usr/local/bin/wp

# Create necessary directories
RUN mkdir -p /run/php /var/www/inception

# Copy configuration files
COPY ./conf/www.conf /etc/php/8.2/fpm/pool.d/

# Copy and set up the setup script
COPY ./tools/setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup.sh

# Set working directory
WORKDIR /var/www/inception

# Expose PHP-FPM port
EXPOSE 9000

# Entry point and command
ENTRYPOINT ["/bin/bash", "/usr/local/bin/setup.sh"]
CMD ["/usr/sbin/php-fpm8.2", "-F"]