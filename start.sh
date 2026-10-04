#!/usr/bin/env bash
# Launch Agent-Trainer in OpenCode.
# Loads HEVY_API_KEY from .env into the environment so opencode.json can use {env:HEVY_API_KEY}.
set -euo pipefail

# Always run from the project directory so opencode finds opencode.json and .opencode/agents/
cd "$(dirname "${BASH_SOURCE[0]}")"

# Load .env (simple KEY=value lines, no spaces around "="). set -a exports everything it defines.
if [[ -f .env ]]; then
  set -a
  # shellcheck disable=SC1091
  source .env
  set +a
fi

if [[ -z "${HEVY_API_KEY:-}" ]]; then
  echo "HEVY_API_KEY is not set. Add it to .env (HEVY_API_KEY=your_key) and try again." >&2
  exit 1
fi

if ! command -v opencode >/dev/null 2>&1; then
  echo "opencode is not installed or not on your PATH." >&2
  exit 1
fi

# The agent reads and writes here; make sure it exists.
mkdir -p data

# exec replaces this shell with opencode; extra arguments pass through.
exec opencode --agent agent-trainer "$@"
