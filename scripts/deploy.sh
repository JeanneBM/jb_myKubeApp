#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
: "${CLUSTER_NAME:=local-cluster}"
: "${IMAGE_TAG:=local-$(date -u +%Y%m%d%H%M%S)}"
export IMAGE_TAG
if [[ $# -ne 0 ]]; then
    echo "Usage: bash scripts/deploy.sh (configure CLUSTER_NAME and IMAGE_TAG via environment)" >&2
    exit 1
fi
if [[ ! "$CLUSTER_NAME" =~ ^[a-z0-9][a-z0-9-]*$ ]]; then
    echo "CLUSTER_NAME must contain lowercase letters, digits and hyphens." >&2
    exit 1
fi
if [[ ! "$IMAGE_TAG" =~ ^[A-Za-z0-9_][A-Za-z0-9_.-]{0,127}$ ]]; then
    echo "IMAGE_TAG must be a valid Docker tag." >&2
    exit 1
fi
for tool in docker kind kubectl; do
    command -v "$tool" >/dev/null || { echo "Install $tool first; see Manual.md." >&2; exit 1; }
done
docker info >/dev/null
if [[ "$(kind version)" != *"v0.33.0"* ]]; then
    echo "Use kind v0.33.0 with the pinned node image; see Manual.md." >&2
    exit 1
fi
if ! kind get clusters | grep -Fxq "$CLUSTER_NAME"; then
    kind create cluster --name "$CLUSTER_NAME" --config k8s/kind.yaml --wait 180s
fi
context="kind-$CLUSTER_NAME"
# Never apply workloads to whichever unrelated cluster is currently selected.
kubectl --context "$context" cluster-info >/dev/null
bash scripts/build.sh
kind load docker-image --name "$CLUSTER_NAME" \
    "mykubeapp/pycalculator:$IMAGE_TAG" "mykubeapp/g4g7singleton:$IMAGE_TAG"
manifest=$(mktemp)
trap 'rm -f "$manifest"' EXIT
kubectl kustomize k8s | sed \
    -e "s|mykubeapp/pycalculator:dev|mykubeapp/pycalculator:$IMAGE_TAG|g" \
    -e "s|mykubeapp/g4g7singleton:dev|mykubeapp/g4g7singleton:$IMAGE_TAG|g" > "$manifest"
kubectl --context "$context" apply -f "$manifest"
kubectl --context "$context" -n python rollout status deployment/pycalculator-deployment --timeout=180s
kubectl --context "$context" -n java rollout status deployment/g4g7singleton-deployment --timeout=180s
kubectl --context "$context" -n jenkins rollout status deployment/jenkins --timeout=600s
echo "Ready. Run the port-forward commands in Manual.md."
