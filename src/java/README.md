* ```docker build -t g4g7singleton:latest .```
* ```docker tag g4g7singleton:latest jeannebm/g4g7singleton:latest```
* ```docker push jeannebm/g4g7singleton:latest```
* ```kubectl apply -f g4g7singleton-deployment.yaml```
* ```kubectl apply -f g4g7singleton-service.yaml```
* ```kubectl get deployments```
* ```kubectl get services```
