DOCKER_CMD = docker compose -f srcs/docker-compose.yml
STORAGE_ROOT = /home/yaharkat/data
W_VOLUME = $(STORAGE_ROOT)/wordpress
D_VOLUME = $(STORAGE_ROOT)/mariadb

.PHONY: default initialize_volumes build up down reboot log clean fclean re

all: up

initialize_volumes:
	@echo "Initializing directories..."
	mkdir -p $(W_VOLUME)
	mkdir -p $(D_VOLUME)
	@echo "✅ Storage directories ready"

up: initialize_volumes
	@echo "Starting application stack..."
	$(DOCKER_CMD) up --build -d
	@echo "✅ All services are now running"

down:
	@echo "Stopping containers..."
	$(DOCKER_CMD) down
	@echo "✅ All containers stopped"

reboot: down up

log:
	@echo "Showing live logs (Ctrl+C to exit)..."
	$(DOCKER_CMD) logs -f

clean:
	@echo "Cleaning up unused Docker resources..."
	docker system prune -f
	docker volume prune -f
	docker network prune -f
	docker image prune -f
	@echo "✅ Cleanup completed"

fclean: clean
	@echo "⚠️  Purging all persistent data..."
	docker stop $(docker ps -aq) 2>/dev/null; docker rm $(docker ps -aq) 2>/dev/null; docker rmi $(docker images -q) 2>/dev/null; docker volume rm $(docker volume ls -q) 2>/dev/null; docker system prune -a --volumes -f
	rm -rf $(W_VOLUME)/*
	rm -rf $(D_VOLUME)/*
	@echo "✅ Data purge completed"

re: fclean all