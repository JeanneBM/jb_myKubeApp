* ```docker build -t pycalculator:latest .```
* ```docker tag pycalculator:latest jeannebm/pycalculator:latest```
* ```docker push jeannebm/pycalculator:latest```
* ```kubectl apply -f deployment.yaml```
* ```kubectl apply -f service.yaml```
* ```kubectl get deployments```
* ```kubectl get services```
