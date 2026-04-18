# 🛠️ Inception - Developer Guide

> This project has been created as part of the 42 curriculum by cda-fons.

This document provides a technical overview of the infrastructure, aimed at developers and evaluators who want to understand the underlying architecture, scripts, and configurations of this Dockerized environment.

## 📁 Directory Structure

The repository is structured to strictly separate the `Makefile` from the Docker context, as required by the subject:

```text
.
├── Makefile
├── .gitignore
├── README.md
├── USER_DOC.md
├── DEV_DOC.md
└── srcs/
    ├── .env
    ├── docker-compose.yml
    └── requirements/
        ├── mariadb/
        │   ├── conf/
        │   ├── tools/
        │   └── Dockerfile
        ├── nginx/
        │   ├── conf/
        │   ├── tools/
        │   └── Dockerfile
        └── wordpress/
            ├── conf/
            ├── tools/
            └── Dockerfile
```

🐳 Architecture Details
1. The Network

All containers communicate through a custom user-defined bridge network called inception. This allows containers to resolve each other by their service names (e.g., NGINX forwards PHP requests to wordpress:9000, and WordPress connects to the database at mariadb:3306). The default host network is strictly ignored.
2. The Volumes

We use bind mounts mapped to /home/cda-fons/data/ on the host machine. The Makefile ensures these directories are created with sudo privileges before docker-compose runs, preventing permission errors.
⚙️ Container Deep Dive
NGINX (Reverse Proxy)

    Base Image: debian:bookworm

    Setup: A self-signed SSL certificate is generated dynamically during the build phase using openssl.

    Routing: The nginx.conf file is configured to intercept .php requests and forward them via FastCGI to the WordPress container on port 9000. It strictly enforces TLSv1.2 and TLSv1.3.

MariaDB (Database)

    Base Image: debian:bookworm

    Setup: The initialization logic is handled by a custom entrypoint script (mariadb.sh).

    Security: The script creates the database and users dynamically using environment variables from the .env file. It modifies the root password and flushes privileges. The service is kept alive in the foreground using exec mysqld_safe.

WordPress + PHP-FPM (Application Logic)

    Base Image: debian:bookworm

    Setup: We use WP-CLI (WordPress Command Line Interface) to fully automate the installation process.

    Race Condition Handling: The custom entrypoint script (wp_setup.sh) includes a sleep 10 delay before running the WP-CLI installation. This guarantees that MariaDB has enough time to fully initialize the database structure before WordPress attempts to connect, preventing fatal connection errors during startup.

    Execution: After setup, the script hands over control to php-fpm8.2 -F, keeping the PHP processor running in the foreground to listen for NGINX requests.

🐛 Troubleshooting & Debugging

If you are modifying the infrastructure and need to debug, use these commands:

    Check container logs: To see if a script failed (e.g., WordPress failing to connect to MariaDB):
    Bash

    docker logs mariadb
    docker logs wordpress
    docker logs nginx

    Access a running container:
    To inspect the internal file system or check permissions:
    Bash

    docker exec -it wordpress bash

    Total Reset:
    If the volumes get corrupted during development, run make fclean to nuke all containers, images, and physical host data, then make to rebuild from a clean state.