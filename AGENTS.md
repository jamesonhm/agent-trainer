# AGENTS.md

## Status: pre-implementation

Scaffolded so far: `opencode.json` (Hevy MCP) + this file. Still missing: `start.sh`, `.opencode/`
agents/skills, `data/`, any manifest, tests, lint/typecheck, and CI.

- Spec: `docs/plans/2026-10-03-agent-trainer-design.md` ("Project Structure" + "Agent Behavior Flow").
- That tree is a **plan, not reality**. Check the filesystem before assuming any file in it exists,
  and update the doc when the scaffolding lands.
- Don't invent build/test commands. If you add tooling (manifest, scripts, CI), record the exact
  commands here.

## Hevy MCP (opencode.json)

- Local stdio: `npx -y hevy-mcp@6` (npm `hevy-mcp` = github.com/chrisdoc/hevy-mcp). Requires Node
  20+; verified on v6.1.19 / Node 26. Pinned to a major on purpose — tool names are what the
  `tools` globs below match, so an unpinned major could silently re-enable a write tool.
- `HEVY_API_KEY` comes from the **process env** via `{env:HEVY_API_KEY}`; opencode does not read
  `.env` for it. `.env` is only useful if `start.sh` exports it (`set -a; . ./.env; set +a`) before
  exec'ing opencode. Empty value = server fails to start, so wire up `start.sh` rather than
  hardcoding the key in the config.
- `HEVY_MCP_TELEMETRY=0` disables the upstream Sentry/OTel telemetry — this repo handles personal
  health data, so keep it off.
- `timeout: 60000` beats the 5000ms default so first-run `npx` download doesn't drop tool discovery.
- Read-only is enforced twice: `tools: {"hevy_create-*": false, ...}` hides mutating tools *and*
  opencode derives matching `permission` denies from it (visible in `opencode debug config`). When
  upgrading the server, re-check the full tool list in its README and extend the globs — Hevy has no
  delete endpoints, so `create-`/`update-`/`replace-` covers current mutations.
- Verify config changes with `opencode debug config` (prints the resolved config, redacting secrets),
  then restart opencode — config is loaded once at startup.

## Hard constraints (from the design doc)

- **Hevy access is read-only.** Never create, edit, or delete workouts through MCP tools.
- **Every session logs the full conversation** to `data/conversations.md` (see known gap below).
- Session start order is deliberate: `.env` key check -> `data/user.md` -> `data/goals.md` ->
  regular session. Don't skip the profile/goals bootstrap.
- Planning is date-aware: run `date` for "today"/days-since-last-workout math instead of
  assuming the current date.

## Data access

- Primary: Hevy MCP, requires `HEVY_API_KEY` in `.env`.
- Fallback (no key): CSV export via browser-mcp, parsed by
  `.opencode/skills/hevy-export/scripts/parse-csv.py`.
- Keep helper scripts **stdlib-only** (bare `python3`, no venv/manifest exists). CSV parsing via
  the `csv` module — don't add dependencies.

## Local-only, never committed

`.gitignore` excludes `.env` and `data/`. That data holds the user's profile, goals, and workout
history — personal health info.

- Don't commit them, and don't stage them "just to check".
- Don't echo/log `HEVY_API_KEY` or paste file contents into commits or PR descriptions.

## Known gap in the spec

The conversation log path is inconsistent in the design doc: `data/conversations.md` (Constraints
section) vs `data/conversation.md` (Agent Behavior Flow). Pick one, fix the doc, and use that
path consistently in code.
