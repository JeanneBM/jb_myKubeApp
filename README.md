### Namespaces
kubectl create ns py-calculator-ns
kubectl create ns java-welcoming-ns

### Pod 
kubectl run py-calculator-pod --image python:3.8 -- python

kubectl expose pod py-calculator-pod --port 80 --target-port 5000 --protocol TCP

### Deployment

kubectl create deployment py-calculator-deploy --image python:3.8 --replicas 3 -- python
