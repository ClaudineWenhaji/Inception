FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y mariadb-server
RUN rm -rf /var/lib/mysql/*

EXPOSE 3306

COPY ./conf/my_config.cnf /etc/mysql/mariadb.conf.d/
COPY ./tools /var/

RUN chmod +x /var/mariadb.sh

ENTRYPOINT ["/var/mariadb.sh"]
