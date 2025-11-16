#!/bin/bash
# Smith&Vader OS ES - Build Assembly in Docker

set -e

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║        Smith&Vader OS ES - Assembly Build                     ║"
echo "║        Building ARM assembly code...                          ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Error: Docker is not running!"
    exit 1
fi

echo "Building assembly code..."
echo ""

# Run make in container
docker-compose run --rm smithvader-build make

echo ""
echo "✓ Build complete!"
echo ""
echo "Note: The assembly version requires actual Raspberry Pi hardware to run."
echo "Use ./run-demo.sh to run the C demo version instead."
echo ""
