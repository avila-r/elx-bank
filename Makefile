DOCKER_COMPOSE_FILE = docker-compose.dev.yml

up:
	docker compose -f $(DOCKER_COMPOSE_FILE) up -d
	
down:
	docker compose -f $(DOCKER_COMPOSE_FILE) down