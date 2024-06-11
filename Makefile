# Define the image and container names
IMAGE_NAME=structosarl/dopg-timbrage:latest
CONTAINER_NAME=dopg-timbrage

# Makefile targets
.PHONY: stop remove pull run

# Charging bar function
define charging_bar
@echo -n " "
@for i in {1..10}; do \
    echo -n "#"; \
    sleep 0.1; \
done
@echo " Done!"
endef

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
pull: remove
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
