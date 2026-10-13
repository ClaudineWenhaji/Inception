FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y \
    php8.2 \
    php8.2-mysql \
    wget \
    curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/html

RUN wget https://www.adminer.org/latest.php -O /var/www/html/index.php

RUN chown -R www-data:www-data /var/www/html

WORKDIR /var/www/html

EXPOSE 8080

CMD ["php", "-S", "0.0.0.0:8080"]
