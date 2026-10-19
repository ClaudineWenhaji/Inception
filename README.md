*This project has been created as part of the 42 curriculum by clwenhaj.*

# Inception - System Administration & Docker Infrastructure

## Description
The **Inception** project aims to broaden knowledge in system administration and DevOps practices by building a small, secure, and fully containerized infrastructure using **Docker and Docker Compose.** 

The main objective is to design, configure, and deploy an isolated multi-container architecture from scratch on a virtual machine. Every service runs in its own dedicated container built from a base Debian Linux image, without relying on pre-built DockerHub application images or shortcuts.

### Infrastructure Architecture

```
                        +-------------------------------------------------+
                        |                   HOST VM                       |
                        |              (clwenhaj.42.fr)                   |
                        +-------------------------------------------------+
                                                |
                                        [ Port 443 (HTTPS) ]
                                                v
                        +-------------------------------------------------+
                        |            INCEPTION DOCKER NETWORK             |
                        |                                                 |
                        |  +-----------------+     +-------------------+  |
                        |  |  NGINX Container|     | Adminer Container |  |
                        |  |  (TLS v1.2/v1.3)|     | (Port 8080)       |  |
                        |  +--------+--------+     +---------+---------+  |
                        |           |                        |            |
                        |     [FastCGI/9000]                 |            |
                        |           v                        |            |
                        |  +-----------------+               |            |
                        |  | WordPress + FPM |               |            |
                        |  +----+-------+----+               |            |
                        |       |       |                    |            |
                        |       |  +----+--------------------+            |
                        |       |  |                                      |
                        |       v  v                                      |
                        |  +----+------------+     +-------------------+  |
                        |  | MariaDB Database|     |  Redis Cache      |  |
                        |  | (Port 3306)     |     |  (Port 6379)      |  |
                        |  +-----------------+     +-------------------+  |
                        |                                                 |
                        |  +-----------------+     +-------------------+  |
                        |  | FTP Container   |     | cAdvisor / Static |  |
                        |  | (Port 21 / PASV)|     | (Port 8081 / 80)  |  |
                        |  +-----------------+     +-------------------+  |
                        +-------------------------------------------------+
```

---

## Technical Comparisons & Key Architectural Choices

### 1. Virtual Machines vs Docker Containers
* **Virtual Machines (VMs):** Emulate a complete hardware stack, requiring a dedicated Guest Operating System. This results in heavy resource overhead, slow startup times, and substantial storage footprints.
* **Docker Containers:** Share the host kernel and isolate processes at the OS level using Linux namespaces and cgroups. Containers are lightweight, start in seconds, and share resources efficiently without hardware virtualization overhead.

### 2. Docker Secrets vs Environment Variables
* **Environment Variables (`.env`):** Useful for non-sensitive configuration parameters (such as database names, domain names, hostnames). However, they can easily leak via process inspection (`docker inspect`), process listings (`ps`), or application crash logs.
* **Docker Secrets:** Securely mount sensitive data (passwords, credentials) as temporary memory-backed files in `/run/secrets/<secret_name>` inside containers. They are never written to disk or exposed in environment variables.

### 3. Docker Network vs Host Network
* **Host Network (`--net=host`):** Removes network isolation between the container and the Docker host, exposing container sockets directly to the host's interfaces (strictly forbidden in Inception).
* **Docker Bridge Network:** Creates an isolated private Virtual Ethernet bridge network. Containers communicate securely using container name aliases as DNS endpoints without exposing internal ports directly to the host machine.

### 4. Docker Volumes vs Bind Mounts
* **Bind Mounts:** Directly map a host directory to a container path. They depend heavily on the host directory structure and file permissions.
* **Docker Named Volumes:** Managed entirely by Docker daemon, guaranteeing isolation, proper lifecycle management, and strict driver options. In this project, named local volumes explicitly bind data persistence to `/home/clwenhaj/data/`.

---

## Instructions

### Prerequisites
* Operating System: Debian or Ubuntu Virtual Machine.
* Tools: `docker`, `docker compose`, `make`, `sudo`.
* Network domain setup: Map `clwenhaj.42.fr` to `127.0.0.1` in your `/etc/hosts` file:
  ```bash
  echo "127.0.0.1 clwenhaj.42.fr" | sudo tee -a /etc/hosts
  ```

### Quick Start
1. **Clone the repository:**
   ```bash
   git clone https://github.com/username/inception.orig.git inception
   cd inception
   ```

2. **Initialize Secrets:**
   ```bash
   make secrets
   ```
   Fill in raw secret values in `secrets/db_root_password.txt`, `secrets/db_user_password.txt`, `secrets/wp_admin_password.txt`, `secrets/wp_user_password.txt`, and `secrets/ftp_user_password.txt`.

3. **Build and Run Infrastructure:**
   ```bash
   make
   ```

4. **Stop Infrastructure:**
   ```bash
   make down
   ```

5. **Complete Cleanup (Volumes & Data):**
   ```bash
   make fclean
   ```

---

## Resources & AI Usage

### Resources
* [Docker Official Documentation](https://docs.docker.com/)
* [Docker Compose Specification](https://docs.docker.com/compose/)
* [NGINX SSL/TLS Configuration Guide](https://nginx.org/en/docs/http/configuring_https_servers.html)
* [WordPress WP-CLI Command Reference](https://developer.wordpress.org/cli/commands/)
* [MariaDB Knowledge Base](https://mariadb.com/kb/en/)

### AI Usage Disclosure
Artificial Intelligence (Gemini / ChatGPT) was used in accordance with 42 AI guidelines for:
* **Debugging & Syntax Check:** Diagnostic assistance for shell script syntax (`tools/mariadb.sh`, `tools/wordpress.sh`) and Docker Compose volume binding rules.
* **Architecture Validation:** Clarifying Docker secret mounting mechanisms (`/run/secrets/`) and PID 1 entrypoint best practices.
* **Documentation Formatting:** Structuring technical comparisons and Markdown templates.
* **Verification:** All AI suggestions were manually tested, reviewed, and validated on the target Linux environment.
