#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
: "${CLUSTER_NAME:=local-cluster}"
context="kind-$CLUSTER_NAME"
log_dir=$(mktemp -d)
pids=()
cleanup() {
    for pid in "${pids[@]}"; do kill "$pid" 2>/dev/null || true; done
    rm -rf "$log_dir"
}
trap cleanup EXIT
kubectl --context "$context" -n python port-forward --address 127.0.0.1 svc/pycalculator-service 15000:80 >"$log_dir/python" 2>&1 &
pids+=("$!")
kubectl --context "$context" -n java port-forward --address 127.0.0.1 svc/g4g7singleton-service 18080:80 >"$log_dir/java" 2>&1 &
pids+=("$!")
kubectl --context "$context" -n jenkins port-forward --address 127.0.0.1 svc/jenkins 18081:8080 >"$log_dir/jenkins" 2>&1 &
pids+=("$!")
for url in http://127.0.0.1:15000/healthz http://127.0.0.1:18080/healthz http://127.0.0.1:18081/login; do
    if ! curl --fail --silent --show-error --retry 20 --retry-connrefused --retry-delay 1 --max-time 5 "$url" >/dev/null; then
        cat "$log_dir"/* >&2
        exit 1
    fi
done
python - <<'PY'
from urllib.error import HTTPError
from urllib.parse import urlencode
from urllib.request import urlopen

data = urlencode({'x': '7', 'y': '2', 'operation': 'division'}).encode()
with urlopen('http://127.0.0.1:15000/calculations', data=data, timeout=5) as response:
    assert '>3.5</div>' in response.read().decode()
bad = urlencode({'x': '7', 'y': '0', 'operation': 'division'}).encode()
try:
    urlopen('http://127.0.0.1:15000/calculations', data=bad, timeout=5)
    raise AssertionError('Division by zero should return 400')
except HTTPError as error:
    assert error.code == 400
with urlopen('http://127.0.0.1:18080/', timeout=5) as response:
    body = response.read().decode()
    assert all(message in body for message in ('Guten Tag!', 'Czesc!', 'Hola!'))
print('Python, Java and Jenkins HTTP smoke tests passed')
PY
