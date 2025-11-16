#!/bin/bash
# Quick test script for the demo

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║        Smith&Vader OS ES - Demo Test                          ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Check if demo exists
if [ ! -f "demo" ]; then
    echo "Building demo..."
    make clean && make
    if [ $? -ne 0 ]; then
        echo "❌ Build failed!"
        exit 1
    fi
    echo "✓ Build successful!"
else
    echo "✓ Demo already built"
fi

echo ""
echo "Demo executable info:"
ls -lh demo
file demo

echo ""
echo "Testing basic execution..."
echo ""
echo "The demo will start. To test:"
echo "  1. Enter a username when prompted"
echo "  2. Press 'q' when you see the game board"
echo "  3. This will exit cleanly"
echo ""
echo "Press Enter to start the test..."
read

# Run with automatic quit
echo "q" | ./demo

echo ""
echo "✓ Demo test complete!"
echo ""
echo "To play for real: ./demo"
echo "Or use Docker: cd .. && ./run-demo.sh"
