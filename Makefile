# Define the image and container names
IMAGE_NAME=structosarl/dopg-timbrage:latest
CONTAINER_NAME=dopg-timbrage

# Patterns for the charging bar
PATTERN_BEGIN="»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»"
PATTERN_END="«««««««««««««««««««««««««««««««««««««««««««««"

# Include .env file
include ./.env

# Makefile targets
.PHONY: login stop remove pull run

define charging_bar
	@echo -n " "
	@for i in $$(seq 1 40); do \
		echo -n "»"; \
		sleep 0.1; \
	done
	@echo -e "\033[0;32m $(PATTERN_END) Done!\033[0m"
endef

# Login to Docker
login:
	@echo "Checking Docker login status..."
	@if ! docker info > /dev/null 2>&1; then \
		echo "Logging in to Docker..."; \
		echo "$(DOCKER_PASSWORD)" | docker login --username "$(DOCKER_USERNAME)" --password-stdin > /dev/null 2>&1; \
		echo "Logged in to Docker."; \
	else \
		echo "Already logged in to Docker."; \
	fi
	$(charging_bar)

# Stop the container
stop:
	@echo "Stopping container $(CONTAINER_NAME)..."
	@docker stop $(CONTAINER_NAME) > /dev/null 2>&1 || true
	$(charging_bar)

# Remove the container
remove: stop
	@echo "Removing container $(CONTAINER_NAME)..."
	@docker rm $(CONTAINER_NAME) > /dev/null 2>&1 || true
	@echo "Removing image $(IMAGE_NAME)..."
	@docker rmi $(IMAGE_NAME) > /dev/null 2>&1 || true
	$(charging_bar)

# Pull the latest image from Docker Hub
pull: login remove
	@echo "Pulling the latest image $(IMAGE_NAME) from Docker Hub..."
	@docker pull $(IMAGE_NAME) > /dev/null 2>&1
	$(charging_bar)

# Run the container
run: pull
	@echo "Running container $(CONTAINER_NAME) with image $(IMAGE_NAME)..."
	@docker run --restart unless-stopped -d --name $(CONTAINER_NAME) -p 3000:3000 $(IMAGE_NAME) > /dev/null 2>&1
	$(charging_bar)
	@docker ps

# Default target
all: run