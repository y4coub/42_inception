DOCKER_CMD = docker compose 
STORAGE_ROOT = /home/yaharkat/data
W_VOLUME = $(STORAGE_ROOT)/wordpress
D_VOLUME = $(STORAGE_ROOT)/mariadb

.PHONY: default initialize_volumes build up down reboot log clean fclean re

all: build up

initialize_volumes:
	@echo "initializing directories..."
	mkdir -p $(W_VOLUME)
	mkdir -p $(D_VOLUME)
	@echo "✅ Storage directories ready"

build: initialize_volumes
	$(DOCKER_CMD) build
	@echo "✅ Build process completed"

up: initialize_volumes
	@echo "uping application stack..."
	$(DOCKER_CMD) up -d
	@echo "✅ All services are now running"

down:
	@echo " containers..."
	$(DOCKER_CMD) down
	@echo "✅ All containers stopped"

reboot: down up

log:
	@echo " live logs (Ctrl+C to exit)..."
	$(DOCKER_CMD) logs -f

clean:
	@echo "Cleaning up unused Docker resources..."
	docker system prune -f
	docker volume prune -f
	docker network prune -f
	docker image prune -f
	@echo "✅ clean completed"

fclean: clean
	@echo "⚠️  Purging all persistent data..."
	docker rmi -f $(docker images -aq)
	rm -rf $(W_VOLUME)/*
	rm -rf $(D_VOLUME)/*
	@echo "✅ Data purge completed"

re: fclean all