SRCS		= srcs/docker-compose.yml
DATA_DIR	= /home/clwenhaj/data

SECRETS_DIR     = secrets

all: up

up: create_dirs check_secrets
	@docker compose -f $(SRCS) up -d --build

check_secrets:
	@if [ ! -d $(SECRETS_DIR) ]; then \
		echo "Error: run 'make secrets' first"; \
		exit 1; \
	fi
secrets:
	@mkdir -p $(SECRETS_DIR)
	@touch $(SECRETS_DIR)/db_root_password.txt
	@touch $(SECRETS_DIR)/db_user_password.txt
	@touch $(SECRETS_DIR)/ftp_user_password.txt
	@touch $(SECRETS_DIR)/wp_admin_password.txt
	@touch $(SECRETS_DIR)/wp_user_password.txt    

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

.PHONY: all up down start stop clean fclean re create_dirs secrets check_secrets
