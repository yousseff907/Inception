# Inception - Docker Infrastructure

## 🏗️ Architecture Overview
```
┌─────────────────────────────────────────────────────────────┐
│                        INTERNET                              │
│                (Port 443 HTTPS, Ports 20-21 FTP)            │
└──────────────────────────┬──────────────────────────────────┘
                           │
                           ▼
              ┌────────────────────────┐
              │   NGINX Container      │
              │   - TLS/SSL (443)      │
              │   - Reverse Proxy      │
              └───────────┬────────────┘
                          │
        ┌─────────────────┼─────────────────┬──────────────┐
        │                 │                 │              │
        ▼                 ▼                 ▼              ▼
   WordPress          Adminer           Netdata       Static Site
   (FastCGI)          (9000)            (19999)          (80)
        │
        ├──────┬──────────┐
        ▼      ▼          ▼
    MariaDB  Redis      FTP
    (3306)   (6379)  (20-21)
                    (21000-21010)

                    ┌──────────────────────┐
                    │  Docker Volumes      │
                    │  (Persistent Data)   │
                    ├──────────────────────┤
                    │ /home/admin/data/    │
                    │  ├── wordpress/      │
                    │  └── mariadb/        │
                    └──────────────────────┘
```

## 📦 Mandatory Services

### NGINX
- **Port:** 443 (HTTPS only)
- **Purpose:** Web server, SSL termination, reverse proxy
- **Connects to:** WordPress, Adminer, Netdata, Static Site
- **SSL:** Self-signed certificate (TLSv1.2/1.3)

### WordPress + PHP-FPM
- **Port:** 9000 (internal)
- **Purpose:** Content Management System
- **Connects to:** MariaDB (database), Redis (cache)
- **Features:** WP-CLI, Redis Object Cache plugin
- **Users:** 2 WordPress users (admin + editor)

### MariaDB
- **Port:** 3306 (internal)
- **Purpose:** MySQL database server
- **Data:** Persistent in `/home/admin/data/mariadb`
- **Database:** WordPress database with 2 users

## 🎁 Bonus Services

### Adminer
- **Port:** 9000 (internal, accessed via `/adminer`)
- **Purpose:** Web-based database management
- **Access:** Login with MariaDB credentials
- **Features:** Browse tables, run SQL queries

### Netdata
- **Port:** 19999 (internal, accessed via `/netdata/`)
- **Purpose:** Real-time system monitoring
- **Features:** Live CPU, RAM, disk, network graphs
- **Metrics:** Container and host system performance

### Static Website
- **Port:** 80 (internal, accessed via `/website/`)
- **Purpose:** Simple HTML static site
- **Technology:** NGINX serving HTML/CSS

### Redis Cache
- **Port:** 6379 (internal)
- **Purpose:** WordPress object caching
- **Memory:** 256MB limit with LRU eviction
- **Performance:** Reduces database queries, speeds up page loads

### FTP Server
- **Ports:** 20-21, 21000-21010 (external)
- **Purpose:** File transfer access to WordPress files
- **User:** FTP user with access to `/var/www/html`
- **Features:** Upload themes, plugins, media files

## 🔒 Network

- **Network Name:** `inception`
- **Type:** Bridge (internal Docker network)
- **External Access:** 
  - Port 443 (NGINX) - Primary entry point
  - Ports 20-21, 21000-21010 (FTP) - Bonus service

## 💾 Volumes

- `wordpress_data` → `/home/admin/data/wordpress`
- `mariadb_data` → `/home/admin/data/mariadb`
- **Persistence:** Data survives container restarts and rebuilds

## 🚀 Usage
```bash
# Start everything
make

# Start without rebuild
make up

# Stop containers
make down

# Stop containers (keep them)
make stop

# Clean everything (remove containers and images)
make clean

# Clean everything including volumes
make fclean

# Rebuild from scratch
make re
```

## 🌐 Access

### Main Site
- **Domain:** `https://yitani.42.fr` (add to `/etc/hosts`)
- **Public IP:** `https://YOUR_EC2_IP`
- **WordPress Admin:** `https://yitani.42.fr/wp-admin`

### Bonus Services
- **Adminer:** `https://yitani.42.fr/adminer`
- **Netdata:** `https://yitani.42.fr/netdata/`
- **Static Site:** `https://yitani.42.fr/website/`

### FTP Access
```bash
ftp YOUR_EC2_IP 21
# Username: ftpuser
# Password: ftppass
```

## ⚙️ Configuration

- **Environment Variables:** `srcs/.env`
- **Docker Compose:** `srcs/docker-compose.yml`
- **Dockerfiles:** `srcs/requirements/[service]/Dockerfile`
- **NGINX Config:** `srcs/requirements/nginx/conf/nginx.conf`

## 🔑 Default Credentials

### WordPress
- **Admin:** Set in `.env` (`WP_ADMIN_USER` / `WP_ADMIN_PASSWORD`)
- **Editor:** Set in `.env` (`WP_USER` / `WP_USER_PASSWORD`)

### MariaDB
- **Database:** `wordpress`
- **User:** Set in `.env` (`MYSQL_USER` / `MYSQL_PASSWORD`)
- **Root:** Set in `.env` (`MYSQL_ROOT_PASSWORD`)

### FTP
- **User:** Set in `.env` (`FTP_USER` / `FTP_PASS`)

## 📋 Project Structure
```
Inception/
├── Makefile
├── README.md
└── srcs/
    ├── .env
    ├── docker-compose.yml
    └── requirements/
        ├── mariadb/
        │   ├── Dockerfile
        │   ├── conf/
        │   └── tools/
        ├── nginx/
        │   ├── Dockerfile
        │   └── conf/
        ├── wordpress/
        │   ├── Dockerfile
        │   ├── conf/
        │   └── tools/
        └── bonus/
            ├── adminer/
            ├── ftp/
            ├── netdata/
            ├── redis/
            └── website/
```

## ✅ Features

- ✅ TLSv1.2/1.3 only
- ✅ Custom Dockerfiles (no pre-built images except Alpine/Debian)
- ✅ Persistent data with volumes
- ✅ Automatic container restart on crash
- ✅ Environment variables for configuration
- ✅ Docker network isolation
- ✅ No infinite loops (proper daemon processes)
- ✅ No hardcoded passwords in Dockerfiles
- ✅ Domain name configuration
- ✅ 2 WordPress users
- ✅ Full bonus (5 additional services)

## 🧪 Testing

### Test Persistence
```bash
# Make changes to WordPress (upload image, create post)
# Restart containers
make down && make
# Changes should persist
```

### Test Redis Cache
```bash
# Check cache is working
docker exec redis-cache redis-cli DBSIZE
# Visit WordPress site
curl -k https://yitani.42.fr
# Check cache again (should show cached items)
docker exec redis-cache redis-cli DBSIZE
```

### Test FTP
```bash
ftp localhost 21
# Login with ftpuser/ftppass
ftp> ls
ftp> cd wp-content
ftp> quit
```

### Test Monitoring
- Visit `https://yitani.42.fr/netdata/` for real-time system metrics
- Visit `https://yitani.42.fr/adminer` to browse database

## 🛠️ Troubleshooting

### Container won't start
```bash
docker logs CONTAINER_NAME
```

### Network issues
```bash
docker network inspect srcs_inception
```

### Volume issues
```bash
ls -la /home/admin/data/
```

### Clear everything and start fresh
```bash
make fclean
make
```

## 📚 Technologies Used

- Docker & Docker Compose
- NGINX (Web Server & Reverse Proxy)
- WordPress (CMS)
- MariaDB (Database)
- PHP-FPM (PHP Processor)
- Redis (Caching)
- vsftpd (FTP Server)
- Netdata (Monitoring)
- Adminer (Database UI)
- Debian Bookworm (Base OS)

## 🎓 Learning Outcomes

- Container orchestration with Docker Compose
- Reverse proxy configuration
- SSL/TLS certificate management
- Database management and persistence
- Caching strategies for web applications
- System monitoring and observability
- FTP server configuration
- Docker networking and volumes
- Cloud deployment (AWS EC2)