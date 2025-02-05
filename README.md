The project is a locally deployed Kubernetes environment with a single cluster, where CI/CD, a Python application, and a Java application are organized into separate namespaces for clear isolation and management.

1. Launch the environment:

* ```docker build -t my-k8s-cluster .```
* ```docker run --privileged -d --name k8s-cluster my-k8s-cluster```
* ```docker exec -it k8s-cluster bash```
* ```kind get clusters```
* ```kind create cluster```
  
  ![obraz](https://github.com/user-attachments/assets/86c3e0fd-4e55-41d6-977a-15e5f838be33)

* kind-control-plane

![obraz](https://github.com/user-attachments/assets/29bea509-b87e-4b28-944b-6b93126c5142)

* local-cluster-control-plane

![obraz](https://github.com/user-attachments/assets/e7de3e79-ca90-4367-81e3-79e22ea93c85)
![obraz](https://github.com/user-attachments/assets/6df5d56a-3822-418f-99fc-16e12de127ce)




  
Details: 
* K8S is starting with a hypervisor
![Screenshot from 2025-02-05 16-59-43](https://github.com/user-attachments/assets/01ee5c66-11cc-4521-83d2-f7b74937b566)
![obraz](https://github.com/user-attachments/assets/5c0ef073-9060-4d07-b018-015840de31c5)
