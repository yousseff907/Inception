# Inception

your-repo/
│
├── Makefile                              ← Automation commands (build, start, stop, clean)
├── README.md                             ← Project documentation
├── .gitignore                            ← Prevent secrets from being committed
│
├── secrets/                              ← 🔒 Sensitive data (NEVER commit!)
│   ├── .gitkeep
│   ├── credentials.txt                   ← WordPress admin credentials
│   ├── db_password.txt                   ← Database user password
│   └── db_root_password.txt              ← Database root password
│
└── srcs/                                 ← Main source directory
    ├── docker-compose.yml                ← 🎼 Orchestration file (defines all services)
    ├── .env                              ← 🔒 Environment variables (NEVER commit!)
    │
    └── requirements/                     ← Container definitions
        │
        ├── mariadb/                      ← 🗄️ Database container
        │   ├── Dockerfile                ← How to build MariaDB image
        │   ├── .dockerignore             ← Files to exclude from build
        │   ├── conf/                     ← MariaDB config files (my.cnf, etc.)
        │   └── tools/                    ← Setup scripts (init-db.sh, etc.)
        │
        ├── nginx/                        ← 🌐 Web server container
        │   ├── Dockerfile                ← How to build NGINX image
        │   ├── .dockerignore             ← Files to exclude from build
        │   ├── conf/                     ← NGINX config (nginx.conf, SSL certs)
        │   └── tools/                    ← Setup scripts
        │
        ├── wordpress/                    ← 📝 Application container
        │   ├── Dockerfile                ← How to build WordPress image
        │   ├── .dockerignore             ← Files to exclude from build
        │   ├── conf/                     ← PHP-FPM & WordPress config
        │   └── tools/                    ← Setup scripts (wp-install.sh, etc.)
        │
        ├── tools/                        ← 🔧 General project tools
        │
        └── bonus/                        ← ⭐ Additional services (optional)
            ├── redis/                    ← Cache service
            ├── ftp/                      ← FTP server
            ├── adminer/                  ← DB management UI
            └── ...

---

all:        # Build and start everything
up:         # Start containers
down:       # Stop and remove containers
stop:       # Stop containers (keep config)
clean:      # Remove containers and images
fclean:     # Remove everything including volumes
re:         # Rebuild from scratch
```

---

## 📊 Architecture Diagram
```
┌─────────────────────────────────────────────────────────────┐
│                        INTERNET (WWW)                        │
└───────────────────────────┬─────────────────────────────────┘
                            │
                            │ HTTPS (Port 443)
                            │ TLSv1.2/1.3
                            ▼
        ┌───────────────────────────────────────────┐
        │         COMPUTER HOST (VM)                │
        │                                           │
        │  ┌────────────────────────────────────┐  │
        │  │     Docker Network "inception"     │  │
        │  │                                    │  │
        │  │  ┌──────────────────────────┐     │  │
        │  │  │   NGINX Container        │     │  │
        │  │  │   - Port 443 (external)  │     │  │
        │  │  │   - SSL/TLS termination  │     │  │
        │  │  │   - Reverse proxy        │     │  │
        │  │  └──────────┬───────────────┘     │  │
        │  │             │ Port 9000            │  │
        │  │             │ (FastCGI)            │  │
        │  │             ▼                      │  │
        │  │  ┌──────────────────────────┐     │  │
        │  │  │  WordPress Container     │     │  │
        │  │  │  - PHP-FPM on port 9000  │     │  │
        │  │  │  - WordPress core        │     │  │
        │  │  │  - No web server!        │     │  │
        │  │  └──────────┬───────────────┘     │  │
        │  │             │ Port 3306            │  │
        │  │             │ (MySQL protocol)     │  │
        │  │             ▼                      │  │
        │  │  ┌──────────────────────────┐     │  │
        │  │  │   MariaDB Container      │     │  │
        │  │  │   - Database on port 3306│     │  │
        │  │  │   - Stores WP data       │     │  │
        │  │  └──────────┬───────────────┘     │  │
        │  │             │                      │  │
        │  └─────────────┼──────────────────────┘  │
        │                │                          │
        │  ┌─────────────▼──────────────────────┐  │
        │  │    Docker Volumes (Host)           │  │
        │  │                                    │  │
        │  │  /home/yitani/data/wordpress/     │  │
        │  │  ├── wp-content/                  │  │
        │  │  ├── wp-config.php                │  │
        │  │  └── ...                          │  │
        │  │                                    │  │
        │  │  /home/yitani/data/db/            │  │
        │  │  └── mysql data files             │  │
        │  └────────────────────────────────────┘  │
        └───────────────────────────────────────────┘

Legend:
  ▬▬▬▶  Network connection
  ┌──┐  Container
  ──▶   Data flow
```

---

## 🔄 Complete Workflow
```
1. USER types: make
   └─▶ Makefile executes docker-compose

2. Docker Compose reads docker-compose.yml
   └─▶ Builds 3 images from Dockerfiles
   └─▶ Creates network "inception"
   └─▶ Creates volumes (db_data, wp_data)

3. Containers start in order:
   ┌─▶ MariaDB starts first
   │   └─▶ Initializes database
   │   └─▶ Creates users
   │
   ├─▶ WordPress starts (waits for MariaDB)
   │   └─▶ Connects to database
   │   └─▶ Installs WordPress
   │   └─▶ Starts PHP-FPM on port 9000
   │
   └─▶ NGINX starts (waits for WordPress)
       └─▶ Listens on port 443
       └─▶ Proxies to WordPress:9000

4. USER visits: https://yitani.42.fr
   └─▶ Browser connects to port 443 (NGINX)
   └─▶ NGINX forwards to WordPress:9000
   └─▶ WordPress queries MariaDB:3306
   └─▶ Response flows back to browser

5. Data persistence:
   └─▶ Database files → /home/yitani/data/db/
   └─▶ WordPress files → /home/yitani/data/wordpress/

---

✅ Key Requirements Checklist
Infrastructure:

 3 separate containers (NGINX, WordPress, MariaDB)
 Custom Dockerfiles (no DockerHub images except base OS)
 Alpine or Debian base (penultimate stable version)
 Docker Compose orchestration
 Dedicated Docker network
 2 Docker volumes with host binding

Security:

 TLSv1.2 or TLSv1.3 only
 Port 443 only (no port 80)
 No passwords in Dockerfiles
 Environment variables via .env
 Secrets stored locally (gitignored)
 Admin username ≠ "admin"

Container Rules:

 No latest tag
 No infinite loops (tail -f, sleep infinity)
 Proper daemon processes (PID 1)
 Auto-restart on crash
 No network: host or --link

WordPress Database:

 2 users (1 admin + 1 regular)
 Admin name doesn't contain "admin"

Domain:

 Domain: login.42.fr → localhost
 Example: yitani.42.fr → 127.0.0.1

File Organization:

 Makefile at root
 srcs/ contains docker-compose.yml
 secrets/ gitignored
 Volumes at /home/login/data/


🚀 Implementation Order

Setup structure (✓ already done)
Create MariaDB (database first)
Create WordPress (depends on database)
Create NGINX (entry point, depends on WordPress)
Write docker-compose.yml (orchestrate all)
Create Makefile (automation)
Test locally
Add bonus services (optional)
