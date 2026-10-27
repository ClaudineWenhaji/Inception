# indique a Docker sous quel OS doit tourner ma VM
FROM debian:bookworm

# RUN: Lancer une commande sur ma VM. 
# Ici je mets a jour et j'installe les commandes et paquets 
RUN apt-get update && \
    apt-get install -y nginx curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# je copie mon fichier nginx.conf a partir du lieu du Dockerfile
# vers ou je veux copier sur ma VM
COPY ./conf/nginx.conf /etc/nginx/conf.d/default.conf

# Génération automatique du certificat SSL pendant le build
RUN mkdir -p /etc/nginx/ssl
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -out /etc/nginx/ssl/clwenhaj.42.fr.crt \
    -keyout /etc/nginx/ssl/clwenhaj.42.fr.key \
    -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=clwenhaj.42.fr/UID=clwenhaj"

# EXPOSE informe Docker que le conteneur ecoute Nginx sur le port reseau 443
# qui est dispo seulement pour la communication entre conteneurs internes

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
