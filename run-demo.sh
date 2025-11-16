#!/bin/bash
# Smith&Vader OS ES - Run Demo in Docker

set -e

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║        Smith&Vader OS ES - DEMO VERSION                       ║"
echo "║        Running in Docker container...                         ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Error: Docker is not running!"
    exit 1
fi

echo "Starting demo..."
echo ""

# Run demo in interactive mode
docker-compose run --rm smithvader-demo
