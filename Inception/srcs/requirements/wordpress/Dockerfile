FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y \
    php8.2-fpm \
    php8.2-mysql \
    php8.2-gd \
    php8.2-mbstring \
    curl \
    mariadb-client \
    php8.2-cli && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# PHP-FPM Config.
COPY ./conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

# Telechargement et Extraction des fichiers sources wordpress
# ainsi que sauvergarde directe dans /var/www/html
RUN mkdir -p /run/php /var/www/html
RUN curl -o /tmp/wordpress.tar.gz https://wordpress.org/latest.tar.gz && \
    tar -xvf /tmp/wordpress.tar.gz -C /var/www/html --strip-components=1 && \
    rm /tmp/wordpress.tar.gz

# Telechargement de WP-CLI (WordPress Command Line Interface)
# Outil qui permet d'installer, configurer et admisnistrer wordpress
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Donne la propriete de tous les fichiers wordpress a l'utilisateur www-data
# qui est le compte sous lequel tourne NGINX et PHP-FTP
RUN chown -R www-data:www-data /var/www/html
WORKDIR /var/www/html

# Lancement du script d'initialisation
# wordpress.sh cree les utilisateurs, configure MariaDB et lie Redis
COPY ./tools/wordpress.sh /var/
RUN chmod +x /var/wordpress.sh

# ouvre le port interne sur lequel PHP-FPM ecoute pour discuter avec NGINX
EXPOSE 9000

# definit mon script comme la commande principale lancee au demarrage du conteneur
ENTRYPOINT ["/var/wordpress.sh"]
