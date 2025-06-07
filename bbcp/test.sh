#!/bin/bash
# Test script to validate the Docker image works correctly

set -e

echo "🧪 Testing bbcp Docker image..."

IMAGE_NAME=${1:-"bbcp:latest"}

echo "📋 Testing basic functionality..."

# Test 1: Check if bbcp responds to --help
echo "  ✓ Testing --help flag..."
docker run --rm "$IMAGE_NAME" --help > /dev/null

# Test 2: Check version output
echo "  ✓ Testing --version flag..."
VERSION=$(docker run --rm "$IMAGE_NAME" --version 2>&1 | head -1)
echo "    Version: $VERSION"

# Test 3: Create test files and test local copy
echo "  ✓ Testing local file copy..."
mkdir -p test_data
echo "Hello, bbcp!" > test_data/source.txt

docker run --rm -v "$(pwd)/test_data:/data" "$IMAGE_NAME" /data/source.txt /data/destination.txt

if [ -f "test_data/destination.txt" ]; then
    CONTENT=$(cat test_data/destination.txt)
    if [ "$CONTENT" = "Hello, bbcp!" ]; then
        echo "    ✅ File copy successful"
    else
        echo "    ❌ File content mismatch"
        exit 1
    fi
else
    echo "    ❌ Destination file not created"
    exit 1
fi

# Cleanup
rm -rf test_data

echo "🎉 All tests passed!"
echo "✅ bbcp Docker image is working correctly"
