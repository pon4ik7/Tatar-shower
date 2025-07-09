#!/bin/sh
set -e

if [ "$MIGRATE" = "true" ]; then
  echo ">>> Running DB migrations (up)"
  /app/goose -dir /migrations postgres "$DATABASE_URL" up

  echo ">>> Migrations applied, entering standby until shutdown"
  cleanup() {
      echo ">>> Caught shutdown signal, running 'goose down'"
      /app/goose -dir /migrations postgres "$DATABASE_URL" down
    }
    trap cleanup TERM INT

  tail -f /dev/null & wait
fi

exec "/app/$BINARY_NAME"
