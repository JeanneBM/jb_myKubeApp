# Local deployment manual

## Prerequisites

Use Linux, macOS, or WSL2 with a running Docker daemon and Bash. Allocate at least
4 CPUs and 6 GiB RAM to Docker for the node, Jenkins and the two applications.

Install kind **v0.33.0** using its [official release](https://github.com/kubernetes-sigs/kind/releases/tag/v0.33.0)
and kubectl **v1.35.8** using the [official installation instructions](https://kubernetes.io/docs/tasks/tools/).
Verify downloaded checksums. The kind configuration pins the compatible Kubernetes
1.35.8 node digest. Do not replace it with a floating `latest` tag.

```bash
docker info
kind version
kubectl version --client
```

For local tests also install Python 3.12 and a **JDK 21** (including `javac` and `jar`).

## Start or update the lab

```bash
bash entrypoint.sh
```

This is a host script. It does not start a nested Docker daemon.
All kubectl operations explicitly target `kind-local-cluster`.
It creates namespaces, uses kind's `standard` dynamic storage class, builds and loads
images, applies the root Kustomize configuration, and waits for readiness.

A different dedicated cluster can be selected:

```bash
CLUSTER_NAME=my-lab IMAGE_TAG=my-version bash scripts/deploy.sh
```

If you supply `IMAGE_TAG`, use a new tag whenever the source changes. Otherwise the
script generates a timestamp tag to trigger a fresh rollout.
Reusing an existing cluster does not upgrade its Kubernetes node image.
Create a new cluster to change that image, backing up Jenkins first.

## Access applications

Run each command in a separate terminal:

```bash
kubectl --context kind-local-cluster -n python port-forward svc/pycalculator-service 5000:80
kubectl --context kind-local-cluster -n java port-forward svc/g4g7singleton-service 8080:80
kubectl --context kind-local-cluster -n jenkins port-forward svc/jenkins 8081:8080
```

- Python calculator: http://localhost:5000
- Java singleton greetings: http://localhost:8080
- Jenkins setup and login: http://localhost:8081

Services are ClusterIP. No LoadBalancer provider, Ingress controller, DNS entry,
or public exposure is needed. Substitute your cluster name in the context if changed.

For the initial Jenkins unlock password, retrieve it locally:

```bash
kubectl --context kind-local-cluster -n jenkins exec deployment/jenkins -- cat /var/jenkins_home/secrets/initialAdminPassword
```

Use the setup wizard to create your own administrator and install required plugins.

## Verify

```bash
bash scripts/smoke-test.sh
kubectl --context kind-local-cluster get pods,pvc -A
```

The smoke test opens temporary loopback port forwards on 15000, 18080 and 18081,
checks health/login, verifies calculator success and division-by-zero rejection,
and checks all three Java greetings. It closes its forwards afterwards.

If a rollout fails:

```bash
kubectl --context kind-local-cluster get events -A --sort-by=.lastTimestamp
kubectl --context kind-local-cluster -n python logs deployment/pycalculator-deployment
kubectl --context kind-local-cluster -n java logs deployment/g4g7singleton-deployment
kubectl --context kind-local-cluster -n jenkins logs deployment/jenkins
```

## Storage and migration from the old manifests

Jenkins now uses one controller with `Recreate` updates and a dynamically provisioned
`standard` PVC. The old `manual` PVC's storage class cannot be changed in place.
Do not apply the new storage manifest over that PVC expecting migration.

For an existing installation:

1. Stop builds and take a complete, consistent backup of `JENKINS_HOME` outside the
   old cluster. Follow the [Jenkins backup guide](https://www.jenkins.io/doc/book/system-administration/backing-up/).
2. Create this version in a **new, differently named cluster**.
3. Stop the new Jenkins controller, restore the backup to its new PVC using a
   temporary maintenance pod, preserve ownership UID/GID 1000, then start the controller.
   Plan Jenkins/plugin upgrades against the restored version; a fresh setup is simpler
   if the old data is not needed.
4. Verify jobs, credentials and files before removing the old environment.

No script deletes an existing PVC or cluster. Storage is inside the kind node;
it survives controller replacement but is lost when the cluster is deleted.
Back it up outside Docker before cleanup.

## Cleanup

Only when the lab and its Jenkins data are no longer needed:

```bash
kind delete cluster --name local-cluster
```
