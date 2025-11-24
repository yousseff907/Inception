# Inception Project

This repository contains a full Docker-based infrastructure that hosts a secure WordPress website powered by MariaDB and served through NGINX using HTTPS. All services are containerized, isolated, and orchestrated using Docker Compose, following the requirements of the 42 Inception project.

---

## 📁 Project Structure

```
your-repo/
│
├── Makefile                              # Automation commands (build, start, stop, clean)
├── README.md                             # Project documentation
├── .gitignore                            # Prevent secrets from being committed
│
├── secrets/                              # Sensitive data (NEVER commit!)
│   ├── .gitkeep
│   ├── credentials.txt                   # WordPress admin credentials
│   ├── db_password.txt                   # Database user password
│   └── db_root_password.txt              # Database root password
│
└── srcs/                                 # Main source directory
    ├── docker-compose.yml                # Orchestration file (defines all services)
    ├── .env                              # Environment variables (NEVER commit!)
    │
    └── requirements/                     # Container definitions
        │
        ├── mariadb/                      # Database container
        │   ├── Dockerfile
        │   ├── .dockerignore
        │   ├── conf/                     # MariaDB config
        │   └── tools/                    # Setup scripts (init-db.sh)
        │
        ├── nginx/                        # Web server container
        │   ├── Dockerfile
        │   ├── .dockerignore
        │   ├── conf/                     # NGINX config, SSL
        │   └── tools/
        │
        ├── wordpress/                    # Application container
        │   ├── Dockerfile
        │   ├── .dockerignore
        │   ├── conf/                     # PHP-FPM & WP config
        │   └── tools/                    # wp-install.sh, etc.
        │
        ├── tools/                        # General tools
        │
        └── bonus/                        # Optional services
            ├── redis/
            ├── ftp/
            ├── adminer/
            └── ...
```

---

## 🎛️ Makefile Commands

```
all       # Build and start everything
up        # Start containers
down      # Stop and remove containers
stop      # Stop containers (config kept)
clean     # Remove containers and images
fclean    # Remove everything including volumes
re        # Rebuild everything from scratch
```

---

## 📊 Architecture Overview

```
INTERNET
   │ HTTPS 443
   ▼
┌───────────────────────┐
│      NGINX (443)      │
│  - SSL termination     │
│  - Reverse proxy       │
└───────────┬───────────┘
            │ FastCGI 9000
            ▼
┌───────────────────────┐
│   WordPress (PHP-FPM) │
│  - No web server       │
└───────────┬───────────┘
            │ MySQL 3306
            ▼
┌───────────────────────┐
│      MariaDB (DB)     │
└───────────┬───────────┘
            │
            ▼
Docker Volumes
 - /home/login/data/wordpress
 - /home/login/data/db
```

---

## 🔄 System Workflow

1. User runs `make`.
2. Docker Compose builds images and creates the `inception` network.
3. Volumes are created on the host machine.
4. Containers start in the proper order:

   * **MariaDB** initializes and creates users.
   * **WordPress** installs itself and connects to the DB.
   * **NGINX** starts HTTPS and proxies to WordPress.
5. User visits `https://login.42.fr`.
6. Request flows → NGINX → WordPress → MariaDB → back to browser.

---

## ✔️ Requirements Checklist

### Infrastructure

* 3 containers: **NGINX**, **WordPress**, **MariaDB**
* Custom Dockerfiles
* Alpine or Debian base images
* Docker Compose orchestration
* Dedicated Docker network
* 2 host-bound volumes

### Security

* TLSv1.2 or TLSv1.3
* Only port 443 open
* No passwords in Dockerfiles
* Admin username must *not* be "admin"
* `.env` and secrets stored locally, not committed

### Container Rules

* No `latest` tags
* No infinite loops (`sleep infinity`, `tail -f`)
* Proper PID 1 daemons
* Auto-restart policies
* No host networking or deprecated `--link`

### Domain

* `login.42.fr` resolves to localhost (127.0.0.1)

### File Organization

* Correct project tree
* Makefile at root
* Volumes in `/home/login/data/`

---

## 🚀 Suggested Implementation Order

1. Create project structure
2. Implement MariaDB container
3. Implement WordPress container
4. Implement NGINX container
5. Write `docker-compose.yml`
6. Write Makefile
7. Test locally
8. Add bonus services
