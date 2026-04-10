# 📖 Inception - User Guide

Welcome to the Inception infrastructure. This guide explains how to interact with the deployed WordPress website, manage its content, and verify its core functionalities.

## 1. Accessing the Website

Your WordPress website is securely served over HTTPS via the NGINX reverse proxy.
- **Public URL:** `https://cda-fons.42.fr`

> **⚠️ Important Note on the SSL Certificate:** > Because this infrastructure uses a self-signed TLS certificate generated specifically for this local environment, your web browser will display a security warning (e.g., "Your connection is not private" or "Warning: Potential Security Risk Ahead"). 
> **This is expected behavior.** You can safely bypass this by clicking on "Advanced" and selecting "Proceed to cda-fons.42.fr (unsafe)".

## 2. Managing WordPress Content

To manage the content, change themes, or add new posts, you need to access the WordPress administration dashboard.

- **Admin Dashboard URL:** `https://cda-fons.42.fr/wp-admin`

### Default User Roles
During the automated installation process, the system automatically provisions two distinct users based on your secure `.env` configuration:

1. **The Administrator:** Has full privileges to manage the entire site, change core settings, and manage other users. *(As per security guidelines, this username strictly avoids the words "admin" or "administrator").*
2. **The Standard User (Author):** Has restricted privileges. This user can write, edit, and publish their own posts, but cannot alter site settings.

*Please refer to your local `srcs/.env` file to retrieve the exact usernames and passwords to log in.*

## 3. Verifying Data Persistence (For Evaluators)

A core feature of this containerized architecture is that your data is safe even if the containers are destroyed. To test the volume persistence, follow this simple workflow:

1. Access the Admin Dashboard and log in.
2. Go to **Posts > Add New**, write a test post, and click **Publish**.
3. Open your terminal at the root of the project and stop the infrastructure:
   ```bash
   make down
