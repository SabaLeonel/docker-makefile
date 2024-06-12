# Define the image and container names
IMAGE_NAME=structosarl/dopg-timbrage:latest
CONTAINER_NAME=dopg-timbrage

# Include .env file
include ./.env

# Set default Docker config file path if not set
CONFIG_FILE=$(HOME)/.docker/config.json

# Detect the correct python interpreter
PYTHON := $(shell which python3 || which python)

# Define the directory of the Makefile
_mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
I := $(patsubst %/,%,$(dir $(_mkfile_path)))

# ANSI color codes
GREEN := \033[0;32m
NC := \033[0m # No Color

# Function to display progress using the Python script
define progress_bar
	@$(PYTHON) $(I)/echo_progress.py --stepno=$1 --nsteps=$2
	@echo "" # Adding an empty line for readability
endef

# Makefile targets
.PHONY: login stop remove pull run

# Login to Docker
login:
	@echo "Checking Docker login status..."
	@if [ -f "$(CONFIG_FILE)" ]; then \
		AUTH_CHECK=$$(jq '.auths | to_entries | length > 0' "$(CONFIG_FILE)"); \
		if [ "$$AUTH_CHECK" = "true" ]; then \
			echo "Already logged in to Docker"; \
		else \
			echo "Logging in to Docker..."; \
			echo "$(DOCKER_PASSWORD)" | docker login --username "$(DOCKER_USERNAME)" --password-stdin > /dev/null 2>&1; \
			echo "$(GREEN)Successfully logged in to docker account$(NC)"; \
		fi \
	else \
		echo "Docker config file not found at $(CONFIG_FILE)"; \
		exit 1; \
	fi
	$(call progress_bar,1,5)	

# Stop the container
stop:
	@echo "Stopping container $(CONTAINER_NAME)..."
	@docker stop $(CONTAINER_NAME) > /dev/null 2>&1 || true
	$(call progress_bar,2,5)
	@echo "\n"

# Remove the container
remove: stop
	@echo "Removing image & container..."
	@docker rm $(CONTAINER_NAME) > /dev/null 2>&1 || true
	@docker rmi $(IMAGE_NAME) > /dev/null 2>&1 || true
	$(call progress_bar,3,5)
	@echo "\n"

# Pull the latest image from Docker Hub
pull: login remove
	@echo "Pulling the latest image $(IMAGE_NAME) from Docker Hub..."
	@docker pull $(IMAGE_NAME) > /dev/null 2>&1
	$(call progress_bar,4,5)
	@echo "\n"

# Run the container
run: pull
	@echo "Running container $(CONTAINER_NAME) with image $(IMAGE_NAME)..."
	@docker run --restart unless-stopped -d --name $(CONTAINER_NAME) -p 3000:3000 $(IMAGE_NAME) > /dev/null 2>&1
	$(call progress_bar,5,5)

# Default target
all: run
