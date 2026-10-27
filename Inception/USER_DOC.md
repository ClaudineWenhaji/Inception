# User Documentation - Inception Infrastructure

This guide provides end users and administrators with simple instructions on how to access, use, and verify the services deployed in the **Inception** stack.

---

## Provided Services

| Service | Purpose | URL / Access |
| :--- | :--- | :--- |
| **WordPress Website** | Main Web Application & Blog | `https://clwenhaj.42.fr` |
| **WordPress Admin** | WP Dashboard & Management | `https://clwenhaj.42.fr/wp-admin` |
| **Adminer** | Database Web Interface | `http://clwenhaj.42.fr:8080` |
| **Static Site** | Showcase Bonus Website | `http://clwenhaj.42.fr:8082` |
| **cAdvisor** | Resource & Metric Monitoring | `http://clwenhaj.42.fr:8081` |
| **FTP Server** | Remote File Access to WP Files | `ftp://clwenhaj.42.fr:21` |

---

## Starting and Stopping the Project

All commands must be run from the root directory of the repository:

* **Start all services:**
  ```bash
  make
  ```
* **Stop all services:**
  ```bash
  make down
  ```
* **Restart all services:**
  ```bash
  make re
  ```

---

## Accessing Credentials

Passwords and sensitive credentials are **never** stored in Git or environment files. They are stored as raw text in local secret files inside the `./secrets/` directory:

* **MariaDB Root Password:** `./secrets/db_root_password.txt`
* **MariaDB User Password:** `./secrets/db_user_password.txt`
* **WordPress Admin Credentials:**
  * Username: Configured in `srcs/.env` (`WP_ADMIN_USER`)
  * Password: `./secrets/wp_admin_password.txt`
* **WordPress Regular User:**
  * Username: Configured in `srcs/.env` (`WP_USER_USER`)
  * Password: `./secrets/wp_user_password.txt`
* **FTP User Password:** `./secrets/ftp_user_password.txt`

---

## How to Connect to Services

### 1. Connecting to WordPress Administration
1. Open your browser and go to `https://clwenhaj.42.fr/wp-admin`.
2. Enter the administrator username (from `.env`) and the password found in `secrets/wp_admin_password.txt`.

### 2. Connecting to Adminer (Database Management)
1. Open your browser and visit `http://clwenhaj.42.fr:8080`.
2. Fill in the connection form:
   * **System:** `MySQL`
   * **Server:** `mariadb`
   * **Username:** `clwenhaj` (or `root`)
   * **Password:** Content of `secrets/db_user_password.txt` (or `secrets/db_root_password.txt`)
   * **Database:** `wordpress_db`

### 3. Connecting via FTP
Connect using an FTP client (e.g., FileZilla or CLI):
```bash
ftp clwenhaj.42.fr 21
# User: cl1cloclo
# Password: <content of secrets/ftp_user_password.txt>
```

---

## Checking Service Health

To check if all services are running properly:

1. **Check container status:**
   ```bash
   docker compose -f srcs/docker-compose.yml ps
   ```
2. **Inspect container logs:**
   ```bash
   docker logs wordpress
   docker logs mariadb
   docker logs nginx
   ```
