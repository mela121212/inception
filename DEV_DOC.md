# Developer Documentation

## Overview

This document describes how to prepare, build, run, inspect, and manage the Inception infrastructure.

The project is designed to run inside a Virtual Machine and uses Docker Compose to manage the different services.

## Prerequisites

The development environment requires:

* A Virtual Machine.
* Docker.
* Docker Compose.
* Make.
* Sufficient disk space for Docker images, containers and volumes.

The project directory must contain the Makefile at its root.

## Project Structure

```text
.
├── Makefile
├── README.md
├── USER_DOC.md
├── DEV_DOC.md
├── secrets/
└── srcs/
    ├── docker-compose.yml
    └── requirements/
        ├── mariadb/
        ├── nginx/
        └── wordpress/
```

Each service has its own directory and Dockerfile.

## Configuration

Configuration values are provided through environment variables.

Sensitive credentials are stored separately in the local `secrets/` directory.

The following types of information must never be committed to Git:

* Database passwords.
* WordPress passwords.
* Root database passwords.
* API keys.
* Other confidential credentials.

The `.gitignore` file excludes local environment files and secret files from version control.

## Secrets

The project uses Docker secrets for confidential credentials.

The secret files are stored locally in:

```text
secrets/
```

The current secret files include:

```text
secrets/db_password.txt
secrets/db_root_password.txt
secrets/wp_admin_password.txt
secrets/wp_user_password.txt
```

These files must remain local and must not be committed to the repository.

## Building the Project

From the root directory:

```bash
make
```

The Makefile is responsible for building the Docker images and starting the infrastructure.

The Docker Compose configuration is located at:

```text
srcs/docker-compose.yml
```

## Docker Compose

The infrastructure is composed of separate containers for:

* NGINX.
* WordPress with PHP-FPM.
* MariaDB.

Each service has its own Dockerfile.

To manually build the Compose project:

```bash
docker compose -f srcs/docker-compose.yml build
```

To start the services:

```bash
docker compose -f srcs/docker-compose.yml up -d
```

To stop the services:

```bash
docker compose -f srcs/docker-compose.yml down
```

## Container Management

List running containers:

```bash
docker ps
```

List all containers:

```bash
docker ps -a
```

View Compose service status:

```bash
docker compose -f srcs/docker-compose.yml ps
```

View logs:

```bash
docker compose -f srcs/docker-compose.yml logs
```

Follow logs in real time:

```bash
docker compose -f srcs/docker-compose.yml logs -f
```

## Volumes

The project uses Docker named volumes for persistent storage.

List volumes:

```bash
docker volume ls
```

Inspect a volume:

```bash
docker volume inspect <volume_name>
```

The project data is stored on the host under:

```text
/home/carmelag/data
```

The persistent storage is used for:

* WordPress database data.
* WordPress website files.

The volumes must remain persistent when containers are stopped or recreated.

## Network

The services communicate through a Docker network defined in the Compose configuration.

List Docker networks:

```bash
docker network ls
```

Inspect a network:

```bash
docker network inspect <network_name>
```

The project does not use host networking.

## NGINX and TLS

NGINX is the only entry point to the infrastructure.

The project requires HTTPS access through port `443` and TLS 1.2 or TLS 1.3.

The NGINX configuration is located inside the NGINX service directory.

## WordPress and PHP-FPM

WordPress runs in its dedicated container together with PHP-FPM.

The WordPress container communicates with MariaDB through the Docker network.

Passwords are obtained from Docker secrets rather than being hard-coded into the Dockerfile.

## MariaDB

MariaDB runs in its own dedicated container.

Its database credentials are provided through the project's environment configuration and Docker secrets.

The database files are stored in the persistent database volume.

## Data Persistence

Persistent data must survive container recreation.

The two required persistent storage areas are:

1. WordPress database data.
2. WordPress website files.

Docker named volumes are used for these two storage areas.

## Cleaning the Environment

Before removing containers or volumes, make sure that persistent data is not required.

To stop the Compose project:

```bash
docker compose -f srcs/docker-compose.yml down
```

To list volumes before removing anything:

```bash
docker volume ls
```

Do not remove project volumes unless you intentionally want to delete the persistent project data.

## Development Workflow

A typical development workflow is:

1. Modify the relevant configuration, Dockerfile or script.
2. Rebuild the affected image.
3. Restart the relevant service.
4. Check the service status.
5. Inspect logs if necessary.
6. Test the website and infrastructure.
7. Check the Git status before committing.

Useful commands include:

```bash
docker compose -f srcs/docker-compose.yml build
docker compose -f srcs/docker-compose.yml up -d
docker compose -f srcs/docker-compose.yml ps
docker compose -f srcs/docker-compose.yml logs
```

## Git and Security

Before committing changes:

```bash
git status
```

Verify that confidential files are ignored:

```bash
git status --ignored
```

The following must remain outside the Git repository:

```text
.env
srcs/.env
secrets/
```

Never use `git add -f` to force confidential files into the repository.

## AI Usage

AI tools may be used as a support resource for understanding Docker concepts, reviewing configuration, troubleshooting, documentation, and repetitive tasks.

Any AI-generated suggestion must be reviewed, understood and tested before being used in the project.
