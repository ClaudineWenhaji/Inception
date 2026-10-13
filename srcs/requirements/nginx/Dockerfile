FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y \
    nginx \
    curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY ./conf/nginx.conf /etc/nginx/conf.d/default.conf

RUN mkdir -p /etc/nginx/ssl

# Génération automatique du certificat SSL pendant le build
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -out /etc/nginx/ssl/clwenhaj.42.fr.crt \
    -keyout /etc/nginx/ssl/clwenhaj.42.fr.key \
    -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=clwenhaj.42.fr/UID=clwenhaj"

COPY conf/nginx.conf /etc/nginx/conf.d/default.conf

RUN mkdir -p /var/www/html
RUN curl -o /tmp/wordpress.tar.gz https://wordpress.org/latest.tar.gz && \
    tar -xvf /tmp/wordpress.tar.gz -C /var/www/html --strip-components=1 && \
    rm /tmp/wordpress.tar.gz

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
