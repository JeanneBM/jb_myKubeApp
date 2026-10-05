# MyKubeApp 🚀

A local Kubernetes lab with a Python calculator, a Java singleton greeting service
and one Jenkins controller. Each component has its own namespace.

## Quick start

Install Docker, kind **v0.33.0**, and kubectl **v1.35.8** as described in [Manual.md](Manual.md).
Run from the repository root:

```bash
bash entrypoint.sh
```

The script creates `local-cluster` if needed, builds both applications from source,
loads uniquely tagged images into kind, applies all namespaces and workloads, and
waits for their rollouts. Run it again to deploy an update.

In separate terminals:

```bash
kubectl --context kind-local-cluster -n python port-forward svc/pycalculator-service 5000:80
kubectl --context kind-local-cluster -n java port-forward svc/g4g7singleton-service 8080:80
kubectl --context kind-local-cluster -n jenkins port-forward svc/jenkins 8081:8080
```

Open Python at http://localhost:5000, Java at http://localhost:8080 and
Jenkins at http://localhost:8081. Port forwarding listens on loopback by default.

## Structure

| Path | Purpose |
| --- | --- |
| `src/python` | Flask application, Gunicorn image and Kubernetes resources |
| `src/java` | Java 21 sources, multi-stage image and Kubernetes resources |
| `src/jenkins` | One controller, dynamic PVC and ClusterIP service |
| `k8s` | Pinned kind node image, namespaces and root Kustomize configuration |
| `scripts` | Build, deploy and HTTP verification |
| `tests` | Python behavior and manifest consistency tests |
| `.github/workflows/ci.yml` | Unit tests, full kind deployment and tested image publishing |
| `Jenkinsfile` | Optional pipeline for an externally configured build agent |

## Verification and delivery

```bash
python3 -m venv .venv
.venv/bin/python -m pip install -r requirements-dev.txt
.venv/bin/python -m pytest -q
bash scripts/test-java.sh  # requires a JDK 21 on PATH
bash scripts/smoke-test.sh # requires the deployed local cluster
```

GitHub Actions runs these checks, builds both images, and deploys Python, Java and
Jenkins into an isolated kind cluster. On a successful push to `main`, it publishes
the **exact tested images** to GHCR, tagged with the full commit SHA:

- `ghcr.io/jeannebm/jb-mykubeapp-pycalculator:<commit-sha>`
- `ghcr.io/jeannebm/jb-mykubeapp-g4g7singleton:<commit-sha>`

Package publishing requires repository Actions to have package write access.
New GHCR packages may be private; set their visibility explicitly if needed.
Local deployment does not require a registry account or credentials.

The Jenkins controller keeps the normal setup wizard enabled; no default admin
password is committed. See [Jenkins setup](src/jenkins/README.md) for optional builds.

## Migration and scope

The former privileged Docker-in-Docker bootstrap and root Dockerfile have been
removed. Run kind on the host instead; do not use the old `docker run --privileged`
instructions. Existing clusters with a `manual` Jenkins PVC need the backup and
migration steps in [Manual.md](Manual.md).

This is a local lab: Jenkins storage survives pod restarts but **not cluster
deletion**. Namespaces organize workloads; they do not provide network isolation.
Application image tags and the kind node digest are fixed per deployment;
Python/Temurin base images still receive updates within their selected runtime lines.
