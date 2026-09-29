# User Documentation

## Overview

This project provides a small web infrastructure composed of several Docker services.

The main services are:

* **NGINX** — HTTPS entry point for the infrastructure.
* **WordPress + PHP-FPM** — website application.
* **MariaDB** — database used by WordPress.

The services communicate through a Docker network and persistent data is stored using Docker named volumes.

## Starting the Project

From the root of the repository, run:

```bash
make
```

The Makefile builds and starts the Docker infrastructure.

After the services have started, check their status with:

```bash
docker ps
```

You can also check the Compose services with:

```bash
docker compose -f srcs/docker-compose.yml ps
```

## Stopping the Project

To stop the project, use:

```bash
make down
```

If the Makefile provides additional management targets, use the targets documented in the Makefile.

## Accessing the Website

The website is accessed through the configured domain:

```text
https://carmelag.42.fr
```

The infrastructure is exposed through HTTPS on port `443`.

NGINX is the only entry point to the infrastructure.

## Accessing the WordPress Administration Panel

The WordPress administration panel is available through the standard WordPress administration URL:

```text
https://carmelag.42.fr/wp-admin/
```

The administrator credentials are stored locally in the project's secrets and must not be committed to Git.

## Credentials

Confidential credentials are stored in:

```text
secrets/
```

The directory contains password files used by the infrastructure.

These files are intentionally ignored by Git.

Do not publish or commit these files.

If credentials need to be changed, update the appropriate local secret files and restart or recreate the relevant services according to the project's configuration.

## Checking the Services

Check running containers with:

```bash
docker ps
```

Check the status of all Compose services with:

```bash
docker compose -f srcs/docker-compose.yml ps
```

View service logs with:

```bash
docker compose -f srcs/docker-compose.yml logs
```

To inspect a specific service, use:

```bash
docker compose -f srcs/docker-compose.yml logs <service>
```

Replace `<service>` with the appropriate Compose service name.

## Checking Persistent Data

The project uses Docker named volumes for persistent WordPress data.

List Docker volumes with:

```bash
docker volume ls
```

The project data is stored on the host under:

```text
/home/carmelag/data
```

The persistent volumes contain the WordPress database data and website files.

## Troubleshooting

If the website is not accessible:

1. Check that the containers are running:

```bash
docker ps
```

2. Check the Compose service status:

```bash
docker compose -f srcs/docker-compose.yml ps
```

3. Check the logs:

```bash
docker compose -f srcs/docker-compose.yml logs
```

4. Check that the domain resolves to the Virtual Machine's local IP address.

5. Check that NGINX is listening on HTTPS port `443`.

6. Check that the required Docker volumes exist:

```bash
docker volume ls
```

7. Check that the required credentials and configuration files are present locally.

## Security

Passwords and other confidential information must not be stored in Dockerfiles or committed to Git.

The project's `.gitignore` excludes the local environment files and secret files from version control.

Never use `git add -f` on confidential credential files.
