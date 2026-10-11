*This project has been created as part of the 42 curriculum by carmelag.*

# Inception

## Description

Inception is a System Administration project from the 42 curriculum. The goal of this project is to build a small infrastructure using Docker and Docker Compose inside a Virtual Machine.

The infrastructure is composed of several dedicated services:

* **NGINX**: the only entry point to the infrastructure. It provides HTTPS access using TLS.
* **WordPress + PHP-FPM**: provides the WordPress website and processes PHP requests.
* **MariaDB**: provides the database used by WordPress.

Each service runs in its own container and is built from its own Dockerfile.

The project also uses Docker networking and named volumes in order to allow the containers to communicate with each other and to persist data.

## Project Structure

```text
.
├── Makefile
├── README.md
├── USER_DOC.md
├── DEV_DOC.md
├── .gitignore
├── secrets/
└── srcs/
    ├── .env
    ├── docker-compose.yml
    └── requirements/
        ├── mariadb/
        ├── nginx/
        └── wordpress/
```
The srcs directory contains the Docker Compose configuration, the .env file, and the Dockerfiles and configuration files required to build the services.

The .env file defines environment variables used to configure the infrastructure, such as database names, usernames, and other service settings. Docker Compose can load this file to substitute variables in docker-compose.yml.

The secrets/ directory contains confidential credentials used by the containers. Both the .env file and sensitive secret files are ignored by Git and must never be committed to the repository.

## Instructions

### Prerequisites

The project must be run inside the Virtual Machine used for the 42 project.

The following software is required:

* Docker
* Docker Compose
* Make

### Configuration

Before starting the project, make sure that the required environment variables and Docker secrets are correctly configured.

Confidential information such as passwords must remain outside the Git repository.

The project uses the domain:

```text
carmelag.42.fr
```

The domain must point to the local IP address of the Virtual Machine.

### Build and start

From the root of the repository:

```bash
make
```

The Makefile is responsible for building and starting the infrastructure through Docker Compose.

### Stop the project

```bash
make down
```

Use the targets provided by the Makefile to manage the project.

### Check the containers

```bash
docker ps
```

### Check Docker Compose services

```bash
docker compose -f srcs/docker-compose.yml ps
```

### View logs

```bash
docker compose -f srcs/docker-compose.yml logs
```

## Architecture

The infrastructure is composed of three main services:

```text
                    HTTPS :443
                        |
                        v
                    NGINX
                        |
                        v
                 WordPress/PHP-FPM
                        |
                        v
                    MariaDB
```

NGINX is the only public entry point. The services communicate through a Docker network.

## Docker

Docker is used to isolate each service in its own container.

Each service has its own Dockerfile and is built from an Alpine or Debian base image as required by the project.

Docker provides lightweight process and filesystem isolation while allowing the different services to communicate through a dedicated Docker network.

## Virtual Machines vs Docker

A Virtual Machine virtualizes an entire operating system and includes its own kernel.

Docker containers share the host kernel while isolating applications and their dependencies.

For this project, the Virtual Machine provides the environment in which Docker runs, while Docker is used to isolate the individual services of the infrastructure.

## Secrets vs Environment Variables

Environment variables are useful for configuration values that do not need to remain confidential.

Sensitive information such as passwords should be stored as Docker secrets rather than being written directly into Dockerfiles or committed to the Git repository.

This project uses environment variables for configuration and Docker secrets for confidential credentials.

## Docker Network vs Host Network

A Docker network provides an isolated network in which the containers can communicate with each other.

Host networking would make the container use the host network directly.

This project uses a dedicated Docker network so that the services can communicate without exposing every container directly to the host.

## Docker Volumes vs Bind Mounts

Docker volumes provide persistent storage managed by Docker.

Bind mounts directly map a directory or file from the host filesystem into a container.

This project uses Docker named volumes for persistent WordPress data, as required by the subject.

The project data is stored on the host under:

```text
/home/carmelag/data
```

## Credentials

Credentials are stored locally in the `secrets/` directory and are ignored by Git.

The repository must never contain passwords, API keys, or other confidential credentials.

## Resources

The following resources are useful for understanding the technologies used in this project:

* Docker Documentation
* Docker Compose Documentation
* NGINX Documentation
* WordPress Documentation
* MariaDB Documentation
* PHP-FPM Documentation

### AI Usage

AI tools were used as a learning and support resource during the project.

They were used to:

* clarify Docker and Docker Compose concepts;
* understand configuration and troubleshooting steps;
* review documentation;
* help identify possible configuration issues;
* assist with repetitive or explanatory tasks.

All generated information and suggestions were reviewed and tested before being incorporated into the project.

## Documentation

Additional documentation is available in:

* `USER_DOC.md` — user and administrator documentation.
* `DEV_DOC.md` — developer and setup documentation.
