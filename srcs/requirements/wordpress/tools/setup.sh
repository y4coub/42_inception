#!/bin/sh

# Check if wp-config.php exists
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

    # Download WordPress using WP-CLI instead of wget
    echo "Downloading WordPress..."
    wp --allow-root --path="$WP_PATH" core download --force

    # Generate wp-config.php directly with WP-CLI
    echo "Configuring WordPress..."
    wp --allow-root --path="$WP_PATH" config create \
        --dbname="$DB_NAME" \
        --dbuser="$DB_USER" \
        --dbpass="$DB_PASSWORD" \
        --dbhost="$DB_HOST" \
        --force

    # Set proper file ownership
    chmod -R 755 /var/www/
    chown -R "$WWW_USER:$WWW_GROUP" /var/www/

    # Install WordPress core
    echo "Installing WordPress core..."
    wp --allow-root --path="$WP_PATH" core install \
        --url="$WP_URL" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL"

    # Create additional user
    echo "Creating additional user..."
    wp --allow-root --path="$WP_PATH" user create \
        "$WP_USER" "$WP_EMAIL" \
        --user_pass="$WP_PASSWORD" \
        --role="$WP_ROLE"

    echo "WordPress setup completed!"

    ###################################
fi

exec "$@"