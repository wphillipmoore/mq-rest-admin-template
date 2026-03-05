#!/usr/bin/env bash
set -euo pipefail

export DOCKER_DEV_IMAGE="${DOCKER_DEV_IMAGE:-dev-{{LANGUAGE_ID}}:{{LATEST_VERSION}}}"
export DOCKER_TEST_CMD="${DOCKER_TEST_CMD:-{{DOCKER_TEST_COMMAND}}}"
# Example (Python): uv sync --frozen --group dev && uv run pytest --cov=...
# Example (Ruby):   bundle install --jobs 4 && bundle exec rubocop && bundle exec rake test
# Example (Go):     go vet ./... && go test -race -count=1 -coverprofile=coverage.out ./...
# Example (Java):   ./mvnw verify -B

if ! command -v docker-test >/dev/null 2>&1; then
  echo "ERROR: docker-test not found on PATH." >&2
  echo "Set up standard-tooling: export PATH=../standard-tooling/scripts/bin:\$PATH" >&2
  exit 1
fi
exec docker-test
