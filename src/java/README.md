# Java singleton greetings

The sources preserve the three original singleton greeting classes and their
console messages. The HTTP adapter makes the existing Kubernetes Service useful:

- GET `/`: German, Polish and Spanish messages as UTF-8 text.
- GET `/healthz`: HTTP 200.
- Unknown paths: HTTP 404; unsupported methods: HTTP 405.

Both compilation and runtime use Java 21. The Docker build creates an executable
JAR with `pattern.WelcomeServer` as its main class; no precompiled JAR is committed.

From the repository root:

```bash
bash scripts/test-java.sh
bash entrypoint.sh
kubectl --context kind-local-cluster -n java port-forward svc/g4g7singleton-service 8080:80
```

Visit http://localhost:8080. The container runs as UID 10001.
To run only the original console example:

```bash
mkdir -p build/classes
javac --release 21 -d build/classes src/pattern/*.java
java -cp build/classes pattern.SingletonPatternDemo
```

Run these last commands from `src/java`, with JDK 21 installed.
