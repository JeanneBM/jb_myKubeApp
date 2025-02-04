#!/bin/bash
set -e

# Start Docker if not running
dockerd &

# Wait for Docker to be ready
until docker info >/dev/null 2>&1; do
  sleep 1
done

# Create Kubernetes cluster with kind (if not already created)
if ! kind get clusters | grep -q "local-cluster"; then
  kind create cluster --name local-cluster
fi

# Create Jenkins namespace
kubectl create namespace jenkins --dry-run=client -o yaml | kubectl apply -f -

# Keep container running
exec "$@"
