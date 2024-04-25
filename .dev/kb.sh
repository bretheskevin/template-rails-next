#!/bin/bash

project_root=$(grep -oP "(?<=alias kb_path=')[^']+" ~/.bashrc)

if [ -d "$project_root" ]; then
  cd "$project_root" || { echo "Failed to change directory to $project_root"; return 1; }
fi

build() {
  docker compose build
}

start() {
  rm -f backend/tmp/pids/server.pid
  docker compose down
  docker compose up
}

console() {
  PROJECT_NAME=$(grep -oP '(?<=PROJECT_NAME=").*(?=")' .env)
  docker exec -it $PROJECT_NAME-backend bash
}

rspec() {
  PROJECT_NAME=$(grep -oP '(?<=PROJECT_NAME=").*(?=")' .env)
  docker exec -it $PROJECT_NAME-backend bash -c "RAILS_ENV=test rspec --color $1"
}

help() {
    echo "Usage: {build|start|console}"
    echo "    b|build: Build the project using docker compose"
    echo "    s|start: Start the project by cleaning up and bringing up docker containers"
    echo "    c|console: Enter the backend container's console"
    echo "    t|test: Run RSpec tests"
}

if [ $# -eq 0 ]; then
    help
    exit 1
fi

case "$1" in
  b|build)
    build
    ;;
  s|start)
    start
    ;;
  c|console)
    console
    ;;
  t|test)
    rspec "${@:2}"
    ;;
  *)
    help
    ;;
esac
