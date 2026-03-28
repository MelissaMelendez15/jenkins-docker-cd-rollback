#!/usr/bin/env bash
set -euo pipefail

PROJECT_NAME="${COMPOSE_PROJECT_NAME:-jenkins-docker-cd-rollback}"
NETWORK_NAME="${PROJECT_NAME}_default"

echo "Deploy: switching to GREEN"
./scripts/switch.sh green

echo "Healthcheck after switch (through nginx on compose network)..."
if ! docker run --rm --network "${NETWORK_NAME}" curlimages/curl:8.7.1 -fsS http://nginx/health; then
    echo
    echo "Healthcheck failed. Rolling back to BLUE..."
    ./scripts/rollback.sh
    exit 1
fi

echo
echo "Deploy OK. GREEN is now live."
echo "Active version:"
docker run --rm --network "${NETWORK_NAME}" curlimages/curl:8.7.1 -fsS http://nginx/version
echo