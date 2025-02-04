The project is a single Kubernetes environment with one cluster containing CICD, Python App and Java App in separate namespaces.

```sudo docker build -t kube```

```sudo docker run --privileged -v /var/run/docker.sock:/var/run/docker.sock kube```
