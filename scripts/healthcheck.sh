#!/usr/bin/env bash
set -euo pipefail

# Si pasa URL, usa curl normal. Si no, hace healthcheck desde el contenedor nginx.
if [[ $# -ge 1 ]]; then
    URL="$1"
    echo "checking health: $URL"
    CODE=$(curl -s -o /dev/null -w "%{http_code}" "$URL")
else
    echo "checking health via nginx container (http://localhost/health)"
    CODE=$(docker compose exec -T nginx sh -lc 'curl -s -o /dev/null -w "%{http_code}" http://localhost/health')
fi

if [[ "$CODE" -ne 200 ]]; then
    echo "Healthcheck failed (HTTP $CODE)"
    exit 1
fi

echo "Healthcheck OK (HTTP 200)"