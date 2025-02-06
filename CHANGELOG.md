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
* automatic start of the Jenkins environment - pv,pvc,deploy was created manually
* automatic job creation in the new Jenkins with custom configuration by adding the appropriate content in the bash shell in Jenkins directory
