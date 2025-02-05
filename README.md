The project is a locally deployed Kubernetes environment with a single cluster, where CI/CD, a Python application, and a Java application are organized into separate namespaces for clear isolation and management.

```docker build -t my-k8s-cluster .```

```docker run --privileged -d --name k8s-cluster my-k8s-cluster```

```docker exec -it k8s-cluster bash```


