# iTerm AI Agents Bundle

Skills and helper scripts for controlling iTerm from coding agents.

The bundle gives agents a small, JSON-oriented command surface for iTerm:

- inspect windows, tabs, sessions, and TTYs
- create splits and a 2x2 grid
- launch commands in new panes
- set iTerm badges with OSC 1337
- send commands to explicit sessions
- capture iTerm screenshots for visual validation
- run support-safe diagnostics

## Skills

- `iterm-control`: topology, splits, grid, badges, send, screenshot
- `iterm-workspace`: caller/current-tab targeting rules
- `iterm-diagnostics`: read-only health checks and optional badge test

## Install

On this machine, Codex discovers skills from `~/.agents/skills`, and Claude Code
uses `~/.claude/skills`. Use this pair to avoid duplicate skill entries:

```bash
./install.sh --agents --claude
```

For Codex setups that only read `$CODEX_HOME/skills`, use:

```bash
./install.sh --codex
```

To install every supported target directory:

```bash
./install.sh --claude
./install.sh --agents
./install.sh --all
```

## Example

Create a 2x2 grid and open Codex in the three new panes:

```bash
~/.agents/skills/iterm-control/scripts/iterm-control grid \
  --target caller \
  --rows 2 \
  --cols 2 \
  --command "zsh -lc 'cd /Users/me/project && exec codex'"
```

Set a badge:

```bash
~/.agents/skills/iterm-control/scripts/iterm-control badge --target current --text "Regi"
```

Run diagnostics:

```bash
~/.agents/skills/iterm-diagnostics/scripts/iterm-diagnostics --include-context
```

## Safety Model

The helper prefers explicit `session:<id>` or `tty:<path>` targets. `caller`
matches by TTY when possible. If the agent runtime has no TTY, `caller` falls
back to iTerm's current session and reports `caller-fallback-current` in JSON.

The bundle does not edit iTerm preferences or profiles.
