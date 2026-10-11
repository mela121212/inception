NAME			= inception
COMPOSE 		= docker compose
COMPOSE_FILE	= ./srcs/docker-compose.yml
DATA_DIR		= /home/carmelag/data

all: up

prepare:
	mkdir -p $(DATA_DIR)/mariadb $(DATA_DIR)/wordpress

up: prepare
	$(COMPOSE) -f $(COMPOSE_FILE) up -d --build

build: prepare
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

clean:
	$(COMPOSE) -f $(COMPOSE_FILE) down --remove-orphans

fclean:
	$(COMPOSE) -f $(COMPOSE_FILE) down -v --remove-orphans

re: fclean up

.PHONY: all prepare up build down start stop restart logs ps clean fclean re

re: fclean up

.PHONY: all up build down start stop restart logs ps clean fclean re
