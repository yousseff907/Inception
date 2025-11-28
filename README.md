# Inception - Docker Infrastructure

## 🏗️ Architecture Overview
```
┌─────────────────────────────────────────────────────────────┐
│                        INTERNET                              │
│                      (Port 443 HTTPS)                        │
└──────────────────────────┬──────────────────────────────────┘
                           │
                           ▼
              ┌────────────────────────┐
              │   NGINX Container      │
              │   - TLS/SSL (443)      │
              │   - Reverse Proxy      │
              └───────────┬────────────┘
                          │ FastCGI (9000)
                          ▼
              ┌────────────────────────┐
              │  WordPress Container   │
              │   - PHP-FPM (9000)     │
              │   - WP-CLI             │
              └───────────┬────────────┘
                          │ MySQL (3306)
                          ▼
              ┌────────────────────────┐
              │   MariaDB Container    │
              │   - Database (3306)    │
              └────────────────────────┘

                    ┌──────────────────────┐
                    │  Docker Volumes      │
                    │  (Persistent Data)   │
                    ├──────────────────────┤
                    │ /home/admin/data/    │
                    │  ├── wordpress/      │
                    │  └── mariadb/        │
                    └──────────────────────┘
```

## 📦 Services

### NGINX
- **Port:** 443 (HTTPS only)
- **Purpose:** Web server, SSL termination, reverse proxy
- **Connects to:** WordPress via FastCGI

### WordPress + PHP-FPM
- **Port:** 9000 (internal)
- **Purpose:** Application layer
- **Connects to:** MariaDB for database queries

### MariaDB
- **Port:** 3306 (internal)
- **Purpose:** Database storage
- **Data:** Persistent in volume

## 🔒 Network

- **Network Name:** `inception`
- **Type:** Bridge (internal)
- **External Access:** Only via NGINX on port 443

## 💾 Volumes

- `wordpress_data` → `/home/admin/data/wordpress`
- `mariadb_data` → `/home/admin/data/mariadb`

## 🚀 Usage
```bash
# Start everything
make

# Stop containers
make down

# Clean everything
make fclean

# Rebuild from scratch
make re
```

## 🌐 Access

- **URL:** `https://yitani.42.fr` (add to `/etc/hosts`)
- **Public IP:** `https://YOUR_EC2_IP`
- **Admin Panel:** `/wp-admin`

## ⚙️ Configuration

- **Environment:** `srcs/.env`
- **Docker Compose:** `srcs/docker-compose.yml`
- **Dockerfiles:** `srcs/requirements/[service]/Dockerfile`