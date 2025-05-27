COMPOSE = docker compose -f srcs/docker-compose.yml
USER=yaharkat
DATA_DIR = /home/${USER}/data
W_VOLUME = ${DATA_DIR}/wordpress
D_VOLUME = ${DATA_DIR}/mariadb

all: up

init:
	@mkdir -p ${W_VOLUME} ${D_VOLUME}
	@echo "✅ Volumes initialized at ${DATA_DIR}"

up: init
	@echo "🚀 Starting containers..."
	${COMPOSE} up --build -d
	@echo "✅ All services are up!"

down:
	@echo "🛑 Stopping containers..."
	${COMPOSE} down
	@echo "✅ Containers stopped"

re: down up

logs:
	@${COMPOSE} logs -f

clean:
	@echo "🧹 Cleaning Docker system..."
	docker system prune -f
	docker volume prune -f
	docker network prune -f
	@echo "✅ Docker cleaned"

fclean: down
	@echo "⚠️ Removing all data volumes and images..."
	rm -rf ${W_VOLUME} ${D_VOLUME}
	docker rmi $$(docker images -q) 2>/dev/null || true
	docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	docker network rm $$(docker network ls -q) 2>/dev/null || true
	@echo "✅ Project fully cleaned"

.PHONY: all init up down re logs clean fclean
