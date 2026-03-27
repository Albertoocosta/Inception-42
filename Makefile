NAME = inception
USER = cda-fons
COMPOSE = ./srcs/docker-compose.yml

all: 
	@echo "Building and starting containers..."
	@sudo mkdir -p /home/$(USER)/data/mariadb
	@sudo mkdir -p /home/$(USER)/data/wordpress
	@docker compose -f $(COMPOSE) up -d --build

down:
	@echo "Stopping containers..."
	@docker compose -f $(COMPOSE) down

clean: down
	@echo "Cleaning containers and networks..."
	@docker system prune -a -f

fclean: down
	@echo "Total clean-up (including volumes)..."
	@docker compose -f $(COMPOSE) down --volumes
	@docker system prune --all --force --volumes
	@docker network prune --force
	@docker volume prune --force
	@sudo rm -rf /home/$(USER)/data/mariadb/*
	@sudo rm -rf /home/$(USER)/data/wordpress/*

re: fclean all

.PHONY: all down clean fclean re
