#!/usr/bin/env bash
set -euo pipefail

export DOCKER_DEV_IMAGE="${DOCKER_DEV_IMAGE:-dev-{{LANGUAGE_ID}}:{{LATEST_VERSION}}}"
export DOCKER_TEST_CMD="${DOCKER_TEST_CMD:-{{DOCKER_AUDIT_COMMAND}}}"
# Example (Python): uv sync --frozen --group dev && uv run pip-audit -r requirements.txt -r requirements-dev.txt
# Example (Ruby):   bundle install --jobs 4 && bundle exec bundle-audit check --update
# Example (Go):     govulncheck ./... && go-licenses check ./... --allowed_licenses=...
# Example (Java):   ./mvnw dependency:tree -B -q && ./mvnw license:add-third-party ...

if ! command -v docker-test >/dev/null 2>&1; then
  echo "ERROR: docker-test not found on PATH." >&2
  echo "Set up standard-tooling: export PATH=../standard-tooling/scripts/bin:\$PATH" >&2
  exit 1
fi
exec docker-test
