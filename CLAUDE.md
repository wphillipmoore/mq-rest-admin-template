# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

**Standards reference**: <https://github.com/wphillipmoore/standards-and-conventions>
— active standards documentation lives in the standard-tooling repository under `docs/`.
Repository profile: `standard-tooling.toml`.

## Auto-memory policy

**Do NOT use MEMORY.md.** Never write to MEMORY.md or any file under the
memory directory. All behavioral rules, conventions, and workflow instructions
belong in managed, version-controlled documentation (CLAUDE.md, AGENTS.md,
skills, or docs/). If you want to persist something, tell the human what you
would save and let them decide where it belongs.

## Parallel AI agent development

This repository supports running multiple Claude Code agents in parallel via
git worktrees. The convention keeps parallel agents' working trees isolated
while preserving shared project memory (which Claude Code derives from the
session's starting CWD).

**Canonical spec:**
[`standard-tooling/docs/specs/worktree-convention.md`](https://github.com/wphillipmoore/standard-tooling/blob/develop/docs/specs/worktree-convention.md)
— full rationale, trust model, failure modes, and memory-path implications.
The canonical text lives in `standard-tooling`; this section is the local
on-ramp.

### Structure

```text
~/dev/github/{{PACKAGE_NAME}}/              ← sessions ALWAYS start here
  .git/
  CLAUDE.md, ...                            ← main worktree (usually `develop`)
  .worktrees/                               ← container for parallel worktrees
    issue-<N>-<slug>/                       ← worktree on feature/<N>-<slug>
    …
```

### Rules

1. **Sessions always start at the project root.**
   `cd ~/dev/github/{{PACKAGE_NAME}} && claude` — never from inside
   `.worktrees/<name>/`. This keeps the memory-path slug stable and shared.
2. **Each parallel agent is assigned exactly one worktree.** The session
   prompt names the worktree (see Agent prompt contract below).
   - For Read / Edit / Write tools: use the worktree's absolute path.
   - For Bash commands that touch files: `cd` into the worktree first,
     or use absolute paths.
3. **The main worktree is read-only.** All edits flow through a worktree
   on a feature branch — the logical endpoint of the standing
   "no direct commits to `develop`" policy.
4. **One worktree per issue.** Don't stack in-flight issues. When a
   branch lands, remove the worktree before starting the next.
5. **Naming: `issue-<N>-<short-slug>`.** `<N>` is the GitHub issue
   number; `<short-slug>` is 2–4 kebab-case tokens.

### Agent prompt contract

When launching a parallel-agent session, use this template (fill in the
placeholders):

```text
You are working on issue #<N>: <issue title>.

Your worktree is: /Users/<user>/dev/github/{{PACKAGE_NAME}}/.worktrees/issue-<N>-<slug>/
Your branch is:   feature/<N>-<slug>

Rules for this session:
- Do all git operations from inside your worktree:
    cd <absolute-worktree-path> && git <command>
- For Read / Edit / Write tools, use the absolute worktree path.
- For Bash commands that touch files, cd into the worktree first
  or use absolute paths.
- Do not edit files at the project root. The main worktree is
  read-only — all changes flow through your worktree on your
  feature branch.
```

All fields are required.

## Project Overview

`{{PACKAGE_NAME}}` is a {{LANGUAGE}} wrapper for the IBM MQ administrative REST
API. The project provides typed {{LANGUAGE}} functions for every MQSC command
exposed by the `runCommandJSON` REST endpoint, with automatic attribute name
translation between {{LANGUAGE}} idioms and native MQSC parameter names.

**Project name**: {{PROJECT_NAME}}

**Status**: Pre-alpha (initial setup)

## Development Commands

### Standard Tooling

```bash
cd ../standard-tooling && uv sync                                                # Install standard-tooling
export PATH="../standard-tooling/.venv/bin:../standard-tooling/scripts/bin:$PATH" # Put tools on PATH
git config core.hooksPath ../standard-tooling/scripts/lib/git-hooks               # Enable git hooks
```

### Two-Tier CI Model

Testing is split across two tiers with increasing scope and cost:

**Tier 1 — Local pre-commit (seconds):** Fast smoke tests in a single
container. Enforced via the `.githooks` pre-commit gate on every commit.
No MQ, no matrix.

```bash
./scripts/dev/test.sh        # Tests in dev-{{LANGUAGE_ID}}:{{LATEST_VERSION}}
./scripts/dev/lint.sh        # Lint checks in dev-{{LANGUAGE_ID}}:{{LATEST_VERSION}}
./scripts/dev/typecheck.sh   # Type checking in dev-{{LANGUAGE_ID}}:{{LATEST_VERSION}}
./scripts/dev/audit.sh       # Security audit in dev-{{LANGUAGE_ID}}:{{LATEST_VERSION}}
```

**Tier 2 — PR CI (~8-10 min):** Triggers on `pull_request`. Full version
matrix ({{LANGUAGE_VERSIONS}}), all integration tests, security scanners
(CodeQL, Trivy, Semgrep), standards compliance, and release gates. Workflow:
`.github/workflows/ci.yml`.

Push-CI was retired once `st-validate-local` reached parity with PR-CI.
See wphillipmoore/standard-actions#176 for the parity audit and rationale.

### Environment Setup

```bash
{{ENV_SETUP_COMMANDS}}
```

### Docker-First Testing

All tests can run inside containers — Docker is the only host prerequisite.
The `dev-{{LANGUAGE_ID}}:{{LATEST_VERSION}}` image is built from
`../standard-tooling/docker/{{LANGUAGE_ID}}/`.

```bash
# Build the dev image (one-time, from standard-tooling)
cd ../standard-tooling && docker/build.sh

# Run tests in container
./scripts/dev/test.sh

# Run lint checks in container
./scripts/dev/lint.sh

# Run security audit in container
./scripts/dev/audit.sh
```

Environment overrides:

- `DOCKER_DEV_IMAGE` — override the container image (default: `dev-{{LANGUAGE_ID}}:{{LATEST_VERSION}}`)
- `DOCKER_TEST_CMD` — override the test command

### Validation

```bash
{{VALIDATION_COMMAND}}
```

### Testing

```bash
{{TEST_COMMANDS}}
```

### Local MQ Container

The MQ development environment is owned by the
[mq-rest-admin-dev-environment](https://github.com/wphillipmoore/mq-rest-admin-dev-environment)
repository. Clone it as a sibling directory before running lifecycle
scripts:

```bash
# Prerequisite (one-time)
git clone https://github.com/wphillipmoore/mq-rest-admin-dev-environment.git ../mq-rest-admin-dev-environment

# Start the containerized MQ queue managers
./scripts/dev/mq_start.sh

# Seed deterministic test objects (DEV.* prefix)
./scripts/dev/mq_seed.sh

# Verify REST-based MQSC responses
./scripts/dev/mq_verify.sh

# Stop the queue managers
./scripts/dev/mq_stop.sh

# Reset to clean state (removes data volumes)
./scripts/dev/mq_reset.sh
```

Container details:

- Queue managers: `QM1` and `QM2`
- QM1 ports: `1414` (MQ listener), `9443` (mqweb console + REST API)
- QM2 ports: `1415` (MQ listener), `9444` (mqweb console + REST API)
- Admin credentials: `mqadmin` / `mqadmin`
- Read-only credentials: `mqreader` / `mqreader`
- QM1 REST base URL: `https://localhost:9443/ibmmq/rest/v2`
- QM2 REST base URL: `https://localhost:9444/ibmmq/rest/v2`
- Object prefix: `DEV.*`

## Architecture

{{ARCHITECTURE_SECTION}}

## Key References

**Reference implementation**: `../mq-rest-admin-python` (Python version)

**External Documentation**:

- IBM MQ 9.4 administrative REST API
- MQSC command reference
