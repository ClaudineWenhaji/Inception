FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y nginx && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY conf/index.html /var/www/html/index.html

# Configuration minimale pour écouter sur le port 80 en interne
RUN echo 'server { listen 80; root /var/www/html; index index.html; location / { try_files $uri $uri/ =404; } }' > /etc/nginx/sites-available/default

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
