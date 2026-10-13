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

RUN mkdir -p /run/php /var/www/html

RUN curl -o /tmp/wordpress.tar.gz https://wordpress.org/latest.tar.gz && \
    tar -xvf /tmp/wordpress.tar.gz -C /var/www/html --strip-components=1 && \
    rm /tmp/wordpress.tar.gz

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

RUN chown -R www-data:www-data /var/www/html

WORKDIR /var/www/html

COPY ./tools/wordpress.sh /var/
RUN chmod +x /var/wordpress.sh

EXPOSE 9000

ENTRYPOINT ["/var/wordpress.sh"]
