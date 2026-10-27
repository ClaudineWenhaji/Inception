#!/bin/bash
set -e

# Lecture des secrets Docker injectés par le docker-compose
export MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
export MYSQL_PASSWORD=$(cat /run/secrets/db_user_password)

if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "first run for MariaDB, database is being set up..."

	# create basic mariadb's base system tables
	mariadb-install-db --user=mysql --datadir=/var/lib/mysql

	# start temporary server
	mysqld_safe --datadir=/var/lib/mysql &

	# wait until server ping response
	until mysqladmin ping --silent; do
	    echo "Waiting for the temporary server to start..."
	    sleep 2
	done
	echo "The temporary server is ready. Security settings are being made..."
    
    # set the root password
    mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
    # create project db
    mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"
    
    # create project's user and grant it permissions
	mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
	mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"
	mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
    
	# apply the changes
	mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"

    # properly shut down the temporary server.
    mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown
    echo "installation completed"

else
	# the "else" part of the "if" block
	echo "database is already installed, skipping installation step."

fi

echo "starting MariaDB server..."
exec mysqld_safe --datadir=/var/lib/mysql
