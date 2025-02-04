The project is a locally deployed Kubernetes environment with a single cluster, where CI/CD, a Python application, and a Java application are organized into separate namespaces for clear isolation and management.


```sudo docker build -t kube```

```sudo docker run --privileged -v /var/run/docker.sock:/var/run/docker.sock kube```
