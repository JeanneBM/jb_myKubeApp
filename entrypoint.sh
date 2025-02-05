#!/bin/bash
set -e

# Start Docker daemon in the background
dockerd > /dev/null 2>&1 &

# Wait for Docker to be ready
until docker info >/dev/null 2>&1; do
    echo "Waiting for Docker to start..."
    sleep 2
done

# Create the kind cluster if it does not exist
if ! kind get clusters | grep -q "local-cluster"; then
    kind create cluster --name local-cluster
fi

# Keep the container running
exec "$@"
