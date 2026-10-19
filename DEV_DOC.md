# Developer Documentation - Inception

This document is intended for developers maintaining, extending, or testing the **Inception** containerized infrastructure.

---

## Environment Setup & Prerequisites

### Required Tools
Ensure the host operating system (Debian/Ubuntu VM) has the following packages installed:
```bash
sudo apt update && sudo apt install -y docker.io docker-buildx-plugin docker-compose-plugin make curl git
```

### Domain Mapping
Ensure `/etc/hosts` contains the local domain mapping:
```text
127.0.0.1 clwenhaj.42.fr
```

---

## Configuration & Secrets Structure

The project strictly separates operational variables (`srcs/.env`) from secrets (`secrets/*.txt`).

### File Tree Overview
```text
.
├── Makefile
├── secrets/
│   ├── db_root_password.txt
│   ├── db_user_password.txt
│   ├── ftp_user_password.txt
│   ├── wp_admin_password.txt
│   └── wp_user_password.txt
└── srcs/
    ├── .env
    ├── docker-compose.yml
    └── requirements/
        ├── bonus/
        ├── mariadb/
        ├── nginx/
        └── wordpress/
```

### Initializing Secrets
To generate the required secret directory and files:
```bash
make secrets
```
*Note: Secret files must contain **only** the raw password string without newline characters or variable prefixes.*

---

## Build and Lifecycle Management

All orchestration is managed via the root `Makefile`:

| Target | Action |
| :--- | :--- |
| `make` / `make up` | Creates host data directories, verifies secrets, builds Docker images, and starts containers in detached mode. |
| `make down` | Stops and removes active project containers. |
| `make stop` | Pauses running containers without destroying them. |
| `make start` | Resumes stopped containers. |
| `make clean` | Executes `docker system prune -a --force`. |
| `make fclean` | Stops stack, purges volumes, removes network, and deletes host persistent data (`/home/clwenhaj/data/*`). |
| `make re` | Full rebuild sequence (`fclean` + `all`). |

---

## Data Persistence & Volume Storage

Data is persisted on the Docker Host using Docker Named Volumes backed by local bind mounts:

* **WordPress Files Volume:** `wordpress_data` -> Mounted at `/home/clwenhaj/data/wordpress`
* **MariaDB Database Volume:** `mariadb_data` -> Mounted at `/home/clwenhaj/data/mariadb`

### Volume Mount Verification
To check storage on the host:
```bash
ls -la /home/clwenhaj/data/wordpress
ls -la /home/clwenhaj/data/mariadb
```

---

## Development Debugging Commands

* **Execute shell inside a container:**
  ```bash
  docker exec -it wordpress sh
  docker exec -it mariadb bash
  ```

* **Verify Mounted Docker Secrets inside a container:**
  ```bash
  docker exec -it wordpress cat /run/secrets/db_user_password
  ```

* **Inspect Network Interfaces:**
  ```bash
  docker network inspect srcs_inception-network
  ```