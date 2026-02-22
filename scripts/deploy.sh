#!/usr/bin/env bash
set -euo pipefail

echo "Deploy: switching to GREEN"
./scripts/switch.sh green

echo "Healthcheck after switch..."
if ! ./scripts/healthcheck.sh http://localhost:8080/health; then
    echo "Healthcheck failed. Rolling back to BLUE..."
    ./scripts/rollback.sh
    exit 1
fi

echo "Deploy OK. GREEN is now live."
curl -s http://localhost:8080/version
echo