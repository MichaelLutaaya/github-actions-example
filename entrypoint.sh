#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid

# Exec the container's main process (i.e., CMD specified in Dockerfile)
exec "$@"
