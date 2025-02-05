The project is a locally deployed Kubernetes environment with a single cluster, where CI/CD, a Python application, and a Java application are organized into separate namespaces for clear isolation and management.

1. Launch the environment:

* ```docker build -t my-k8s-cluster .```

* ```docker run --privileged -d --name k8s-cluster my-k8s-cluster```

* ```docker exec -it k8s-cluster bash```

K8S is starting with a hypervisor
![Screenshot from 2025-02-05 16-59-43](https://github.com/user-attachments/assets/01ee5c66-11cc-4521-83d2-f7b74937b566)
![obraz](https://github.com/user-attachments/assets/5c0ef073-9060-4d07-b018-015840de31c5)
