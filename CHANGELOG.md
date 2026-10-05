## Unreleased

Fixed:
* Python startup, validation and error responses; Gunicorn runtime and health endpoint.
* Java source builds on Java 21 and correct executable JAR; HTTP greeting adapter.
* CI dependency paths, meaningful tests and full kind integration checks.
* Jenkins single-controller storage, startup probes and administrator setup.
* Namespace creation, resource requests/limits and application health probes.
* One Kustomize resource tree and executable host deployment/verification scripts.

Changed:
* Removed privileged Docker-in-Docker bootstrap and precompiled Java artifact.
* Replaced LoadBalancer/Ingress assumptions with local ClusterIP port forwarding.
* Replaced static Minikube storage and duplicate Jenkins manifests with kind's standard PVC.
* Publish exact tested commit-tagged application images to GHCR after successful main CI.
* Rewrote setup, migration, persistence and optional Jenkins-agent instructions.

## 00.00.05 (09/02/2025)
## 00.00.04 (08/02/2025)

## 00.00.03 (07/02/2025)
Created:
* src/java
* src/python

## 00.00.02 (06/02/2025)
Created:
* src/jenkins

Updated:
* README.md

## 00.00.01 (05/02/2025)
Updated:
* Dockerfile with deamon 
* entrypoint.sh
* README.md

## 00.00.00 (04/02/2025)
Created:
* Dockerfile
* entrypoint.sh
* jenkins-svc.yaml
  
Update commands in README.md to run kubernetes cluster in a container.

The environment is working and creating a cluster.

Next step:
* automatic start of the Jenkins environment - pv,pvc,deploy was created manually; provide EXTERNAL-IP
* automatic job creation in the new Jenkins with custom configuration by adding the appropriate content in the bash shell in Jenkins directory
