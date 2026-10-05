#!/usr/bin/env bash
# Compatibility entry point: the local cluster now runs on the host Docker daemon.
set -euo pipefail
exec bash "$(dirname "${BASH_SOURCE[0]}")/scripts/deploy.sh" "$@"
