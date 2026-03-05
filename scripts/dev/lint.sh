#!/usr/bin/env bash
set -euo pipefail

export DOCKER_DEV_IMAGE="${DOCKER_DEV_IMAGE:-dev-{{LANGUAGE_ID}}:{{LATEST_VERSION}}}"
export DOCKER_TEST_CMD="${DOCKER_TEST_CMD:-{{DOCKER_LINT_COMMAND}}}"
# Example (Python): uv sync --frozen --group dev && uv run ruff check && uv run ruff format --check .
# Example (Ruby):   bundle install --jobs 4 && bundle exec rubocop
# Example (Go):     go vet ./... && golangci-lint run ./... && gocyclo -over 15 ./mqrestadmin/
# Example (Java):   ./mvnw spotless:check checkstyle:check -B

if ! command -v docker-test >/dev/null 2>&1; then
  echo "ERROR: docker-test not found on PATH." >&2
  echo "Set up standard-tooling: export PATH=../standard-tooling/scripts/bin:\$PATH" >&2
  exit 1
fi
exec docker-test
