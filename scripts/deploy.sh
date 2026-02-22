#!/usr/bin/env bash
set -euo pipefail

PROJECT_NAME="${COMPOSE_PROJECT_NAME:-cd-bluegreen}"
DC="docker compose -p ${PROJECT_NAME}"

echo "Deploy: switching to GREEN"
./scripts/switch.sh green

echo "Healthcheck after switch..."
if ! ./scripts/healthcheck.sh http://localhost:8080/health; then
    echo "Healthcheck failed. Rolling back to BLUE..."
    ./scripts/rollback.sh
    exit 1
fi

echo "Deploy OK. GREEN is now live."
echo "Active version:"
$DC exec -T nginx sh -lc 'curl -s http://localhost/version; echo'