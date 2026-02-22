#!/usr/bin/env bash
set -euo pipefail

PROJECT_NAME="${COMPOSE_PROJECT_NAME:-cd-bluegreen}"
DC="docker compose -p ${PROJECT_NAME}"

# Si pasas URL (modo local/host), hace curl directo.
# Si no pasas URL (modo CI), lo hace desde el contenedor nginx.
if [[ $# -ge 1 ]]; then
    URL="$1"
    echo "checking health: $URL"
    CODE=$(curl -s -o /dev/null -w "%{http_code}" "$URL")
else
    echo "checking health via nginx container (http://localhost/health)"
    CODE=$($DC exec -T nginx sh -lc 'curl -s -o /dev/null -w "%{http_code}" http://localhost/health')
fi

if [[ "$CODE" -ne 200 ]]; then
    echo "Healthcheck failed (HTTP $CODE)"
    exit 1
fi

echo "Healthcheck OK (HTTP 200)"