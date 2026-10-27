#!/bin/sh

# Lecture du secret Docker pour le FTP
export FTP_PASSWORD=$(cat /run/secrets/ftp_user_password)

# Création de l'utilisateur FTP s'il n'existe pas
if ! id "$FTP_USER" >/dev/null 2>&1; then
    useradd -m -d /var/www/html -s /bin/bash "$FTP_USER"
    echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
    echo "$FTP_USER" >> /etc/vsftpd.user_list
fi

chown -R "$FTP_USER":"$FTP_USER" /var/www/html

# Configuration de vsftpd pour le mode passif et la sécurité
cat << EOF > /etc/vsftpd.conf
listen=YES
listen_ipv6=NO
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
dirmessage_enable=YES
use_localtime=YES
xferlog_enable=YES
connect_from_port_20=YES
secure_chroot_dir=/var/run/vsftpd/empty
pam_service_name=vsftpd
rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
ssl_enable=NO
pasv_enable=YES
pasv_min_port=40000
pasv_max_port=40005
userlist_enable=YES
userlist_file=/etc/vsftpd.user_list
userlist_deny=NO
chroot_local_user=YES
allow_writeable_chroot=YES
EOF

mkdir -p /var/run/vsftpd/empty

echo "FTP server started..."
exec vsftpd /etc/vsftpd.conf
