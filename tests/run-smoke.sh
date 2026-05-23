#!/usr/bin/env bash
#
# Smoke test runner: spins up the API in a subprocess against a temp
# SQLite database, runs the ghul-driven HTTP test, tears everything down.
#
# Exit code 0 = all checks passed; non-zero = failure.

set -euo pipefail

WORKTREE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$WORKTREE_ROOT"

TMPDB="$(mktemp -t smoke-XXXXXX.db)"
rm -f "$TMPDB"                          # mktemp creates the file; we want a fresh path
SERVER_LOG="$(mktemp -t smoke-server-XXXXXX.log)"
SERVER_PID=""

cleanup() {
    if [[ -n "${SERVER_PID}" ]]; then
        kill "${SERVER_PID}" 2>/dev/null || true
        wait "${SERVER_PID}" 2>/dev/null || true
    fi
    # Belt-and-braces: kill any leftover ghul-web-api process bound to our port.
    pkill -f 'ghul-web-api\.dll' 2>/dev/null || true
    rm -f "$TMPDB" "$SERVER_LOG"
}
trap cleanup EXIT

echo "==> building API + smoke test"
dotnet build ghul-web-api.ghulproj            >/dev/null
dotnet build tests/smoke-test                 >/dev/null

echo "==> starting API (db=$TMPDB)"
GHUL_WEBAPI_DB="$TMPDB" \
    dotnet run --project ghul-web-api.ghulproj --no-build \
    >"$SERVER_LOG" 2>&1 &
SERVER_PID=$!

echo "==> waiting for server to be ready (pid $SERVER_PID)"
for _ in {1..60}; do
    if grep -q 'Now listening on' "$SERVER_LOG" 2>/dev/null; then
        break
    fi
    if ! kill -0 "$SERVER_PID" 2>/dev/null; then
        echo "!! server exited before becoming ready" >&2
        cat "$SERVER_LOG" >&2
        exit 2
    fi
    sleep 0.5
done

if ! grep -q 'Now listening on' "$SERVER_LOG" 2>/dev/null; then
    echo "!! server did not become ready in time" >&2
    cat "$SERVER_LOG" >&2
    exit 2
fi

echo "==> running smoke test"
if dotnet run --project tests/smoke-test --no-build; then
    echo "==> SMOKE TEST PASSED"
    exit 0
else
    echo "!! SMOKE TEST FAILED" >&2
    echo "--- server log ---" >&2
    cat "$SERVER_LOG" >&2
    exit 1
fi
