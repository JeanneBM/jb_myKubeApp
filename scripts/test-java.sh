#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/../src/java"
build_dir=$(mktemp -d)
trap 'rm -rf "$build_dir"' EXIT
javac --release 21 -d "$build_dir" src/pattern/*.java tests/pattern/*.java
java -cp "$build_dir" pattern.WelcomeServerTest
jar --create --file "$build_dir/app.jar" --main-class pattern.WelcomeServer -C "$build_dir" .
# Check the packaged entry point by launching the same executable used in the image.
PORT=0 java -jar "$build_dir/app.jar" >"$build_dir/server.log" 2>&1 &
server_pid=$!
trap 'kill "$server_pid" 2>/dev/null || true; wait "$server_pid" 2>/dev/null || true; rm -rf "$build_dir"' EXIT
for attempt in {1..50}; do
    if grep -q 'Welcome server listening on port' "$build_dir/server.log"; then
        echo "Executable JAR startup passed"
        exit 0
    fi
    if ! kill -0 "$server_pid" 2>/dev/null; then
        cat "$build_dir/server.log" >&2
        exit 1
    fi
    sleep 0.1
done
cat "$build_dir/server.log" >&2
echo "Executable JAR did not start within 5 seconds" >&2
exit 1
