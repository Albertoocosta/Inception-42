# 🐳 Inception - 42 Project

> This project has been created as part of the 42 curriculum by cda-fons

## 📖 Overview
This project is an introduction to System Administration and virtualization using **Docker**. The goal is to build a complete, orchestrated web infrastructure from scratch, using `docker-compose`. 

The infrastructure hosts a WordPress website running on a LEMP stack (Linux, NGINX, MariaDB, PHP), where each service is isolated in its own dedicated container.

## 🏗️ Infrastructure Architecture

Following the strict rules of the subject, the project consists of 3 isolated containers connected via a custom Docker network (`inception`), without using the host network.

1. **🌐 NGINX (Web Server / Reverse Proxy)**
   - Acts as the single entry point to the infrastructure.
   - Only accepts secure connections over **HTTPS (Port 443)** using **TLSv1.2 or TLSv1.3**.
   - Built from the penultimate stable version of Debian (Bookworm).

2. **📝 WordPress + PHP-FPM (Application)**
   - Contains the core WordPress files and `php-fpm`.
   - Communicates with NGINX via port **9000**.
   - Automated installation and configuration via `WP-CLI` (WordPress Command Line Interface).
   - No NGINX installed in this container.

3. **🗄️ MariaDB (Database)**
   - Hosts the WordPress database.
   - Completely isolated from the host; only accessible by the WordPress container via port **3306**.
   - Configured automatically using a bash script upon container startup.

## 🔒 Security & Constraints
- **No Hardcoded Passwords:** All credentials, database names, and user configurations are securely stored in a `.env` file (which is ignored by Git).
- **No Infinite Loops:** Commands like `tail -f`, `sleep infinity`, or `bash` are **not** used to keep containers alive. Services run in the foreground (e.g., `daemon off;` for NGINX, `mysqld_safe` for MariaDB, and `php-fpm -F` for WordPress).
- **Latest/Alpine Prohibited:** All images are built from `debian:bookworm` (penultimate stable version).

## 💾 Volumes & Data Persistence
To ensure data is not lost when containers are recreated, two named volumes are mapped to the host machine at `/home/cda-fons/data/`:
- `mariadb_data`: Persists the database files.
- `wordpress_data`: Persists the WordPress website files (accessible by NGINX).

---

## 🚀 Installation & Usage

### Prerequisites
- Docker and Docker Compose installed.
- Hostname resolution configured. Add the following line to your `/etc/hosts` file:
  ```text
  127.0.0.1    cda-fons.42.fr

A .env file created inside the srcs directory with your secure credentials.

Makefile Commands

A Makefile is provided at the root of the repository to easily manage the infrastructure:

    Build and start the infrastructure:
    Bash

    make
    # or
    make all

    Stop the containers (without deleting data):
    Bash

    make down

    Stop and clean containers, networks, and dangling images:
    Bash

    make clean

    Deep clean (The ultimate reset):
    Stops containers, removes images, networks, and physically deletes all data from the host volumes (/home/login/data/). Perfect for starting a fresh evaluation.
    Bash

    make fclean

    Rebuild from scratch:
    Bash

    make re

🌐 Accessing the Site

Once the containers are up and running, you can access the WordPress site at:
https://cda-fons.42.fr