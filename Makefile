# Define the image and container names
IMAGE_NAME=structosarl/dopg-timbrage:latest
CONTAINER_NAME=dopg-timbrage

# Makefile targets
.PHONY: stop remove pull run

# Stop the container
stop:
	@echo "Stopping container $(CONTAINER_NAME)..."
	docker stop $(CONTAINER_NAME) || true

# Remove the container
remove: stop
	@echo "Removing container $(CONTAINER_NAME)..."
	docker rm $(CONTAINER_NAME) || true
	@echo "Removing image $(IMAGE_NAME)..."
	docker rmi $(IMAGE_NAME) || true

# Pull the latest image from Docker Hub
pull: remove
	@echo "Pulling the latest image $(IMAGE_NAME) from Docker Hub..."
	docker pull $(IMAGE_NAME)

# Run the container
run: pull
	@echo "Running container $(CONTAINER_NAME) with image $(IMAGE_NAME)..."
	docker run --restart unless-stopped --name $(CONTAINER_NAME) -p 3000:3000 $(IMAGE_NAME)

# Default target
all: run
