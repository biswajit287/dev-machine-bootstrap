#!/bin/bash
# test_linux.sh

IMAGE="ubuntu:22.04"
CONTAINER_NAME="bootstrap-test-linux"

echo "🐳 Starting Linux Test Environment ($IMAGE)..."

# Stop existing test container if it exists
docker rm -f $CONTAINER_NAME > /dev/null 2>&1

# Run the container:
# -v mounts your current folder to /bootstrap inside the container
docker run -it \
  --name $CONTAINER_NAME \
  -v "$(pwd):/bootstrap" \
  -w /bootstrap \
  $IMAGE \
  /bin/bash -c "
        apt-get update && apt-get install -y sudo curl git yq;
        echo '--- System Ready. Starting Bootstrap Test ---';
        ./install.sh
    "
