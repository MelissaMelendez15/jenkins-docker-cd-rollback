#!/usr/bin/env bash
set -euo pipefail

# Forzamos el "project name" de Docker Compose (misma pila siempre)
PROJECT_NAME="${COMPOSE_PROJECT_NAME:-cd-bluegreen}"
DC="docker compose -p ${PROJECT_NAME}"

TARGET="${1:-}"

if [[ "$TARGET" != "blue" && "$TARGET" != "green" ]]; then
  echo "Usage: $0 {blue|green}"
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
UPSTREAM_FILE="$ROOT_DIR/nginx/upstream.conf"

echo "Switching request: $TARGET"
echo "Writing upstream file: $UPSTREAM_FILE"

if [[ "$TARGET" == "blue" ]]; then
  cat > "$UPSTREAM_FILE" <<'EOF'
upstream backend {
    server app_blue:3000;
}
EOF
else
  cat > "$UPSTREAM_FILE" <<'EOF'
upstream backend {
    server app_green:3000;
}
EOF
fi

echo "Reloading Nginx..."
# -T para que no intente modo interactivo en Jenkins
$DC exec -T nginx nginx -s reload

echo "Upstream on host:"
cat "$UPSTREAM_FILE"
echo

echo "Upstream inside container:"
$DC exec -T nginx cat /etc/nginx/conf.d/upstream.conf
echo

echo "Active now (via nginx container):"
$DC exec -T nginx sh -lc 'curl -s http://localhost/; echo'
echo