#!/usr/bin/env bash

set -euo pipefail

# Global variables
# ------------------------------
DOCKER=$(which docker)

CONTAINERS=("ollama" "kotaemon")
NETWORK_NAME="rag_rag"

# Functions
# ------------------------------

# Logging function, handles info, warning and error messages
# Usage: log 1|2|3 "message"
# 1: Info message
# 2: Warning message
# 3: Error message
function log() {
  local type=$1
  local message=$2

  case $type in
  1)
    echo "[*] $message"
    ;;
  2)
    echo "[!] $message"
    ;;
  3)
    echo "[x] $message"
    ;;
  *)
    echo "[?] $message"
    ;;
  esac
}

# Script arguments handler. Handles following arguments:
# -h | --help: Display the help message
# None: If no arguments are provided, the script will start the containers
# -r | --resolution: Add containers names to /etc/hosts file, so that you can access the containers by their names
SETUP_HOST_RESOLUTION=0
function handle_arguments() {
  while [[ "$#" -gt 0 ]]; do
    case $1 in
    -h | --help)
      echo "Usage: $0 [-r | --resolution]"
      exit 0
      ;;
    -r | --resolution)
      SETUP_HOST_RESOLUTION=1
      ;;
    *)
      echo "Unknown argument: $1"
      exit 1
      ;;
    esac
    shift
  done
}

# Add containers names to /etc/hosts file
# Usage: setup_host_resolution "(container list)"
function setup_host_resolution() {
  containers=("$@")

  for container in "${containers[@]}"; do
    if grep -q "$container" /etc/hosts; then
      log 1 "Host resolution already set for $container"
      continue
    fi

    ip=$(get_ip "$container")
    log 1 "$ip $container" | sudo tee -a /etc/hosts
  done
}

# Get the IP address of a container
# Usage: get_ip "container_name"
function get_ip() {
  local container_name=$1
  docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$container_name"
}

# Main
# ------------------------------
function main() {
    log 1 "Starting the containers..."
    $DOCKER compose up -d

    log 1 "Downloading ollama models..."
    $DOCKER compose exec -it ollama ollama pull nomic-embed-text
    $DOCKER compose exec -it ollama ollama pull llama3.1:8b

    NETWORK_SUBNET=$(docker network inspect $NETWORK_NAME | jq '.[].IPAM.Config[].Subnet' | tr -d \")
    log 1 "$NETWORK_NAME network has subnet $NETWORK_SUBNET"

    # Print the IP addresses of the containers
    for container in "${CONTAINERS[@]}"; do
        log 1 "Container $container has IP: $(get_ip "$container")"
    done

    if [ $SETUP_HOST_RESOLUTION -eq 1 ]; then
        setup_host_resolution "${CONTAINERS[@]}"
        log 1 "Host resolution setup complete"
    fi
}

handle_arguments "$@"
main
