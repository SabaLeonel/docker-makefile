# Define the image and container names
IMAGE_NAME=structosarl/dopg-timbrage:latest
CONTAINER_NAME=dopg-timbrage

# Define Docker credentials
DOCKER_USERNAME=structosarl
DOCKER_PASSWORD=<your_password>

# Patterns for the charging bar
PATTERN_BEGIN="»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»"
PATTERN_END="«««««««««««««««««««««««««««««««««««««««««««««"

# Makefile targets
.PHONY: login stop remove pull run

# Charging bar function
define charging_bar
@for ((i=0; i<=${#PATTERN_BEGIN}; i++)); do \
    echo -ne "\r\033[0;32m$${PATTERN_BEGIN:0:i}\033[0m"; \
    sleep 0.1; \
done; \
echo -e "\r\033[0;32m$(PATTERN_END) Done!\033[0m"
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
