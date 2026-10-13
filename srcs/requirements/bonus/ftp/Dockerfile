FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y vsftpd && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY tools/ftp.sh /var/ftp.sh
RUN chmod +x /var/ftp.sh

EXPOSE 20 21 40000-40005

ENTRYPOINT ["/var/ftp.sh"]
