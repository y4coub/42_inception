#!/bin/sh

if [ -f ./wp-config.php ]; then
    echo "WordPress already downloaded"
else
    # ———————————————————————————————
    # Wait for the database to come online
    # ———————————————————————————————
    echo "Waiting for MariaDB port..."
    while ! nc -z "$DB_HOST" 3306; do
        echo "MariaDB port not ready - sleeping"
        sleep 1
    done
    echo "MariaDB port is open!"

    echo "Downloading WordPress..."
    wp --allow-root --path="$WP_PATH" core download --force

    echo "Configuring WordPress..."
    wp --allow-root --path="$WP_PATH" config create \
        --dbname="$DB_NAME" \
        --dbuser="$DB_USER" \
        --dbpass="$DB_PASSWORD" \
        --dbhost="$DB_HOST" \
        --force

    chmod -R 755 /var/www/
    chown -R "$WWW_USER:$WWW_GROUP" /var/www/

    echo "Installing WordPress core..."
    wp --allow-root --path="$WP_PATH" core install \
        --url="$WP_URL" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL"

    echo "Creating additional user..."
    wp --allow-root --path="$WP_PATH" user create \
        "$WP_USER" "$WP_EMAIL" \
        --user_pass="$WP_PASSWORD" \
        --role="$WP_ROLE"

    echo "WordPress setup completed!"

fi

exec "$@"