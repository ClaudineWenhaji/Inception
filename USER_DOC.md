User Documentation

Overview of Services

The stack consists of three core services running inside isolated containers:

NGINX: Acts as the single entry point to the infrastructure, accepting secure connections exclusively via HTTPS (Port 443, using TLSv1.2 or TLSv1.3).

WordPress + PHP-FPM: A fully configured Content Management System serving your website files.

MariaDB: A relational database managing WordPress posts, pages, and user data.

How to Start and Stop the Project

Start the project: Navigate to the root directory and run:

make


Stop the project: Run:

make down


Accessing the Website and Administration Panel
Ensure your host machine maps the custom domain name to your local IP address inside /etc/hosts:

Plaintext

   127.0.0.1 clwenhaj.42.fr
   

    Open your web browser and access the website:

        Main Website: [https://clwenhaj.42.fr](https://clwenhaj.42.fr)

        Admin Panel: [https://clwenhaj.42.fr/wp-admin](https://clwenhaj.42.fr/wp-admin)

Credentials Management

Credentials and database passwords are defined via the environment configuration file (srcs/.env) and securely integrated during container deployment.
Code snippet


http://googleusercontent.com/immersive_entry_chip/2
  - **WordPress Website Files:** `/home/clwenhaj/data/wordpress`
  - **MariaDB Database Files:** `/home/clwenhaj/data/mariadb`
```eof
