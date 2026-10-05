#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
: "${IMAGE_TAG:=dev}"
if [[ ! "$IMAGE_TAG" =~ ^[A-Za-z0-9_][A-Za-z0-9_.-]{0,127}$ ]]; then
    echo "IMAGE_TAG must be a valid Docker tag." >&2
    exit 1
fi
docker build -t "mykubeapp/pycalculator:$IMAGE_TAG" src/python
docker build -t "mykubeapp/g4g7singleton:$IMAGE_TAG" src/java
