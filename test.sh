#!/bin/bash

# Path to the Docker config file
CONFIG_FILE="$HOME/.docker/config.json"

# Check if the config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Docker config file does not exist."
    exit 1
fi

# Extract the auths section and check if it is not empty
AUTH_CHECK=$(jq '.auths | to_entries | length > 0' "$CONFIG_FILE")

if [ "$AUTH_CHECK" = "true" ]; then
    echo "Auths section is not empty."
else
    echo "Auths section is empty."
fi
