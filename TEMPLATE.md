# Template Setup Guide

Follow this checklist after clicking "Use this template" to create your new
mq-rest-admin language port repository.

## 1. Replace all placeholders

Search for `{{` across all files and replace each placeholder:

| Placeholder | Description | Example (Python) | Example (Go) |
| --- | --- | --- | --- |
| `{{PROJECT_NAME}}` | Docker compose project name and repo identifier | `pymqrest` | `mq-rest-admin-go` |
| `{{REPO_NAME}}` | GitHub repository name | `mq-rest-admin-python` | `mq-rest-admin-go` |
| `{{PACKAGE_NAME}}` | Published package/module name | `pymqrest` | `mqrestadmin` |
| `{{LANGUAGE}}` | Programming language display name | `Python` | `Go` |
| `{{LANGUAGE_ID}}` | Language identifier for code fences | `python` | `go` |
| `{{PRIMARY_LANGUAGE}}` | Language for repository profile | `python` | `go` |
| `{{LANGUAGE_VERSION_REQUIREMENT}}` | Minimum version statement | `Python 3.12+` | `Go 1.25+` |
| `{{INSTALL_COMMAND}}` | Package install command | `pip install pymqrest` | `go get github.com/wphillipmoore/mq-rest-admin-go` |
| `{{QUICK_START_EXAMPLE}}` | Code example for README | *(language-specific)* | *(language-specific)* |
| `{{DEV_SETUP_COMMANDS}}` | Developer environment setup | `uv sync --group dev` | `go build ./...` |
| `{{ENV_SETUP_COMMANDS}}` | Environment setup for CLAUDE.md | *(language-specific)* | *(language-specific)* |
| `{{VALIDATION_COMMAND}}` | Local validation command | `uv run python3 scripts/dev/validate_local.py` | `scripts/dev/validate_local.sh` |
| `{{TEST_COMMANDS}}` | Test runner commands | `uv run pytest ...` | `go test ./...` |
| `{{LANGUAGE_TOOLING}}` | Required tools list | `uv 0.10.4` | `Go 1.25+, golangci-lint` |
| `{{SCOPE}}` | Example commit scope | `session` | `mapping` |
| `{{ARCHITECTURE_SECTION}}` | Architecture description for CLAUDE.md | *(language-specific)* | *(language-specific)* |
| `{{LANGUAGE_SETUP}}` | CI language setup steps | `actions/setup-python` | `actions/setup-go` |
| `{{AUDIT_COMMANDS}}` | CI dependency audit steps | `pip-audit`, `pip-licenses` | `govulncheck`, `go-licenses` |
| `{{HEAD_VERSION_CMD}}` | Extract version from HEAD | `python3 -c "import tomllib; ..."` | `grep -oP '...' version.go` |
| `{{MAIN_VERSION_CMD}}` | Extract version from main | `git show origin/main:... \| python3 -c "..."` | `git show origin/main:... \| grep ...` |
| `{{LANGUAGE_VERSIONS}}` | CI matrix versions | `["3.12", "3.13", "3.14"]` | `["1.25", "1.26"]` |
| `{{SETUP_STEPS}}` | CI setup steps | *(language-specific)* | *(language-specific)* |
| `{{LINT_STEPS}}` | CI lint steps | `ruff check`, `mypy` | `go vet`, `golangci-lint` |
| `{{TEST_COMMAND}}` | CI test command | `uv run pytest --cov=...` | `go test -race ./...` |
| `{{CODEQL_LANGUAGE}}` | CodeQL language identifier | `python` | `go` |
| `{{SEMGREP_LANGUAGE}}` | Semgrep language identifier | `python` | `golang` |
| `{{LATEST_VERSION}}` | Latest/default language version for Tier 1/2 | `3.14` | `1.26` |
| `{{LATEST_VERSION_JSON}}` | JSON array with single latest version | `'["3.14"]'` | `'["1.26"]'` |
| `{{LATEST_INTEGRATION_MATRIX_JSON}}` | JSON integration matrix for push CI | *(single-entry matrix)* | *(single-entry matrix)* |
| `{{INTEGRATION_MATRIX_DEFAULT}}` | Full integration matrix default for PR CI | *(full matrix JSON)* | *(full matrix JSON)* |
| `{{DOCKER_TEST_COMMAND}}` | Test command for dev container | `uv sync && uv run pytest` | `go test ./...` |
| `{{DOCKER_LINT_COMMAND}}` | Lint command for dev container | `uv sync && uv run ruff check` | `golangci-lint run ./...` |
| `{{DOCKER_AUDIT_COMMAND}}` | Audit command for dev container | `uv sync && uv run pip-audit` | `govulncheck ./...` |
| `{{VERSION_EXTRACTION}}` | Publish workflow version extraction | *(language-specific)* | *(language-specific)* |
| `{{REGISTRY_CHECK}}` | Check if version exists in registry | *(language-specific)* | *(language-specific)* |
| `{{BUILD_STEPS}}` | Publish workflow build steps | `uv build` | `go build` |
| `{{PUBLISH_STEPS}}` | Publish workflow publish steps | `pypa/gh-action-pypi-publish` | *(language-specific)* |
| `{{VERSION_FILE}}` | File containing version string | `pyproject.toml` | `pkg/version.go` |
| `{{VERSION_REGEX}}` | Regex to match version in file | `^(version\s*=\s*").*("\s*)$` | `(Version\s*=\s*").*(")` |
| `{{VERSION_REPLACEMENT}}` | Replacement pattern for version | `\g<1>{version}\2` | *(language-specific)* |
| `{{DEVELOP_VERSION_CMD}}` | Extract version from develop branch | *(language-specific)* | *(language-specific)* |
| `{{DOCS_SETUP}}` | Docs workflow setup steps | *(language-specific)* | *(language-specific)* |
| `{{DOCS_VERSION_COMMAND}}` | Extract version for docs deploy | *(language-specific)* | *(language-specific)* |
| `{{MIKE_COMMAND}}` | Mike command prefix | `uv run mike` | `mike` |

## 2. Add language-specific `.gitignore` entries

Add entries below the `# === Language-specific entries ===` comment in
`.gitignore` for your language (e.g., `__pycache__/` for Python, `vendor/`
for Go).

## 3. Add language-specific build and config files

Create the language-specific project files:

- **Python**: `pyproject.toml`, `uv.lock`, `requirements.txt`
- **Go**: `go.mod`, `go.sum`, `.testcoverage.yml`, `.golangci.yml`
- **Ruby**: `Gemfile`, `Gemfile.lock`, `.rubocop.yml`
- **Rust**: `Cargo.toml`, `Cargo.lock`, `clippy.toml`

## 4. Set up language-specific linting and formatting

Configure linters, formatters, and type checkers for your language.

## 5. Create GitHub repository settings

- Enable branch protection rules for `main` and `develop`
- Set `develop` as the default branch
- Enable auto-delete head branches
- Configure required status checks matching CI job names

## 6. Set required secrets

| Secret | Purpose |
| --- | --- |
| `PROJECT_TOKEN` | GitHub token for add-to-project workflow |
| `APP_ID` | GitHub App ID for version bump PRs |
| `APP_PRIVATE_KEY` | GitHub App private key for version bump PRs |
| *(language-specific)* | Registry credentials (PyPI OIDC, RubyGems API key, etc.) |

## 7. Import into Qlty Cloud (optional)

If using coverage tracking, import the repository into Qlty Cloud and
configure the coverage upload step.

## 8. Delete this file

Remove `TEMPLATE.md` once setup is complete.

## 9. Create initial commit on develop

Stage all files and create the initial commit:

```bash
git add -A
st-commit --type feat --message "initial repository setup" --agent claude
git push -u origin develop
```
