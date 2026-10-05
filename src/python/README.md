# Python calculator

From the repository root:

```bash
bash entrypoint.sh
kubectl --context kind-local-cluster -n python port-forward svc/pycalculator-service 5000:80
```

Visit http://localhost:5000. POST `/calculations` accepts form fields `x`, `y`,
and `operation` (`addition`, `subtraction`, `multiplication`, `division`).
Invalid numbers, non-finite values, unsupported operations and division by zero
return an error page with HTTP 400. GET `/healthz` reports readiness.

The image runs Gunicorn on 0.0.0.0:5000 as UID 10001.
For development, install requirements and run `python app.py` from this directory.
Developer tools and tests stay outside the runtime image.

Standalone image build, from this directory:

```bash
docker build -t mykubeapp/pycalculator:dev .
docker run --rm -p 127.0.0.1:5000:5000 mykubeapp/pycalculator:dev
```
