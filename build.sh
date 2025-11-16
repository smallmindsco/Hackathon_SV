#!/bin/bash
# Smith&Vader OS ES - Build Script for Docker

set -e

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║        Smith&Vader OS ES - Docker Build System                ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Error: Docker is not running!"
    echo "Please start Docker and try again."
    exit 1
fi

echo "✓ Docker is running"
echo ""

# Build Docker image
echo "📦 Building Docker image..."
docker-compose build smithvader-build

echo ""
echo "✓ Docker image built successfully!"
echo ""
echo "Next steps:"
echo "  1. Run the demo:        ./run-demo.sh"
echo "  2. Build assembly:      ./run-build.sh"
echo "  3. Interactive shell:   docker-compose run smithvader-build"
echo ""
