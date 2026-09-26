#!/bin/bash
set -e

JEKYLL_CMD="bundle exec jekyll serve --host 0.0.0.0 --port 4000 --drafts --watch --config _config.yml,_dev.yml"
JEKYLL_PID=""

start_jekyll() {
  echo "Starting Jekyll..."
  $JEKYLL_CMD &
  JEKYLL_PID=$!
}

stop_jekyll() {
  if [ -n "$JEKYLL_PID" ]; then
    kill "$JEKYLL_PID" 2>/dev/null || true
    wait "$JEKYLL_PID" 2>/dev/null || true
    JEKYLL_PID=""
  fi
}

trap stop_jekyll EXIT

start_jekyll

while inotifywait -q -e modify,create,delete,move -r _plugins/ _config.yml; do
  echo "Config/plugin change detected, restarting Jekyll..."
  sleep 0.5
  stop_jekyll
  start_jekyll
done
