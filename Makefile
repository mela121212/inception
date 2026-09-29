NAME		= inception
COMPOSE 	= docker compose
COMPOSE_FILE	= ./srcs/docker-compose.yml

all: up

up:
	$(COMPOSE) -f $(COMPOSE_FILE) up -d --build

build:
	$(COMPOSE) -f $(COMPOSE_FILE) build

down:
	$(COMPOSE) -f $(COMPOSE_FILE) down

start:
	$(COMPOSE) -f $(COMPOSE_FILE) start

stop:
	$(COMPOSE) -f $(COMPOSE_FILE) stop

restart: down up

logs:
	$(COMPOSE) -f $(COMPOSE_FILE) logs -f

ps:
	$(COMPOSE) -f $(COMPOSE_FILE) ps

clean: down
	docker system prune -f

fclean: down
	docker system prune -af --volumes

re: fclean up

.PHONY: all up build down start stop restart logs ps clean fclean re
