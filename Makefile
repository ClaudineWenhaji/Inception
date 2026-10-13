SRCS		= srcs/docker-compose.yml
DATA_DIR	= /home/clwenhaj/data

all: up

up: create_dirs
	@docker compose -f $(SRCS) up -d --build

down:
	@docker compose -f $(SRCS) down

start:
	@docker compose -f $(SRCS) start

stop:
	@docker compose -f $(SRCS) stop

clean: down
	@docker system prune -a --force

fclean:
	@docker compose -f $(SRCS) down -v
	@docker system prune -a --volumes --force
	@sudo rm -rf $(DATA_DIR)/wordpress/*
	@sudo rm -rf $(DATA_DIR)/mariadb/*

re: fclean all

create_dirs:
	@mkdir -p $(DATA_DIR)/wordpress
	@mkdir -p $(DATA_DIR)/mariadb

.PHONY: all up down start stop clean fclean re create_dirs
