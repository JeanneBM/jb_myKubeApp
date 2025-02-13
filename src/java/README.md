* ```docker build -t g4g7singleton:latest .```
* ```docker tag g4g7singleton:latest jeannebm/g4g7singleton:latest```
* ```docker push jeannebm/g4g7singleton:latest```
* ```kubectl -n java apply -f g4g7singleton-deployment.yaml```
* ```kubectl -n java apply -f g4g7singleton-service.yaml```
* ```kubectl -n java get deployments```
* ```kubectl -n java get services```
