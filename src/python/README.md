* ```docker build -t pycalculator:latest .```
* ```docker tag pycalculator:latest jeannebm/pycalculator:latest```
* ```docker push jeannebm/pycalculator:latest```
* ```kubectl -n python apply -f deployment.yaml```
* ```kubectl -n python apply -f service.yaml```
* ```kubectl -n python get deployments```
* ```kubectl -n python get services```
