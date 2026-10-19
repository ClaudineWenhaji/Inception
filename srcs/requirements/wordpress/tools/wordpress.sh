#!/bin/sh

set -e

export DB_PASSWORD=$(cat /run/secrets/db_user_password)
export WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
export WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

echo "Waiting for MariaDB to be ready..."
until mysqladmin ping -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" --silent; do
    echo "Failed to connect to MariaDB ($DB_HOST), will try again in 2 seconds..."
    sleep 2
done
echo "MariaDB ready!"


if [ ! -f "wp-config.php" ]; then
    echo "wp-config.php not found, creating..."
    SALTS=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)
    cat << EOF > wp-config.php
<?php
define( 'DB_NAME', '${DB_DATABASE}' );
define( 'DB_USER', '${DB_USER}' );
define( 'DB_PASSWORD', '${DB_PASSWORD}' );
define( 'DB_HOST', '${DB_HOST}' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );

/* Bonus  --- REDIS Cache Integration --- FICHIER DE CONF AVEC CONNEXION AU SERVICE REDIS SUR PORT 6379 */

define( 'WP_REDIS_HOST', 'redis' );
define( 'WP_REDIS_PORT', 6379 );
define( 'WP_CACHE', true );

${SALTS}
\$table_prefix = 'wp_';
define( 'WP_DEBUG', false );
if ( ! defined( 'ABSPATH' ) ) {
    define( 'ABSPATH', __DIR__ . '/' );
}
require_once ABSPATH . 'wp-settings.php';
EOF
    echo "wp-config.php has been created."
else
    echo "wp-config.php already exists, skipping creation step."
fi


if ! wp core is-installed --allow-root; then
    echo "WordPress is not installed. Starting installation with wp-cli..."

    wp core install --allow-root \
        --url="https://clwenhaj.42.fr" \
        --title="Inception Project" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}"

    echo "Regular user (${WP_USER_USER}) creating..."
    wp user create --allow-root \
        "${WP_USER_USER}" \
        "${WP_USER_EMAIL}" \
        --role=author \
        --user_pass="${WP_USER_PASSWORD}"

    echo "WordPress and all users have been successfully installed."
else
    echo "WordPress is already installed, skipping the wp-cli installation."
fi

echo "PHP-FPM engine starting..."

# PLUGIN DE COMMUNICATION WORDPRESS-REDIS en CACHE
wp plugin install redis-cache --activate --allow-root || true
wp redis enable --allow-root || true

exec php-fpm8.2 -F
