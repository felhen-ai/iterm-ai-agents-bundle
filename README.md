# iTerm AI Agents Bundle

Give coding agents a real control surface for iTerm.

This bundle turns iTerm into an agent-friendly workspace: agents can inspect the
current layout, open tabs and windows, split panes, label work with badges,
focus the right session, close temporary surfaces, send commands, capture
screenshots, and report health in structured JSON.

If you like the idea of agentic terminal layouts but want to keep using native
iTerm on macOS, this package provides the missing bridge.

## What It Enables

- Start a focused agent workspace from one prompt.
- Open one tab or pane per repo, already in the right directory.
- Put a visible badge on each terminal session so humans can follow the work.
- Route commands to explicit iTerm sessions instead of whichever pane happens
  to be focused.
- Bring a worker back into focus by `session:<id>` or `tty:<path>`.
- Clean up temporary tabs, panes, or windows after a test run.
- Take iTerm screenshots for visual validation.
- Run support-safe diagnostics when AppleScript, permissions, or targeting are
  not behaving.

The core design goal is simple: make iTerm topology something an agent can
reason about deterministically.

## Included Skills

- `iterm-control`: topology, tabs, windows, splits, grids, focus, close, badges,
  send, screenshot, health.
- `iterm-workspace`: caller/current-tab targeting guidance for non-disruptive
  automation.
- `iterm-diagnostics`: read-only diagnostics for AppleScript access,
  permissions, screenshots, and session targeting.

The skills are plain `SKILL.md` packages plus small helper scripts. They are
intended for Codex, Claude Code, and other agents that can load filesystem
skills.

## Command Surface

`iterm-control` is the main CLI. It emits JSON for agent consumption.

```bash
iterm-control identify
iterm-control health
iterm-control list
iterm-control resolve --target caller
iterm-control focus --target session:<id>
iterm-control tab --target caller --command "zsh -lc 'cd /path/to/repo && exec codex'"
iterm-control window --target caller --command "zsh -lc 'cd /path/to/repo && exec codex'"
iterm-control split --target caller --direction right --command "zsh -lc 'cd /path/to/repo && exec codex'"
iterm-control grid --target caller --rows 2 --cols 2 --command "zsh -lc 'cd /path/to/repo && exec codex'"
iterm-control badge --target session:<id> --text "backend"
iterm-control send --target tty:/dev/ttys005 --text "git status"
iterm-control close --target session:<id> --scope tab --force
iterm-control screenshot --output /tmp/iterm-layout.png
```

Targets can be:

- `caller`: the terminal that invoked the agent, matched by TTY when available.
- `current` or `focused`: iTerm's current session.
- `session:<id>`: exact iTerm session id from `list` or `identify`.
- `tty:<path>`: exact TTY path, for example `tty:/dev/ttys005`.

## Install

Clone the repo and copy the skills into your local agent skill directory:

```bash
./install.sh --agents
```

For Claude Code:

```bash
./install.sh --claude
```

For Codex setups that read `$CODEX_HOME/skills`:

```bash
./install.sh --codex
```

To install every supported target:

```bash
./install.sh --all
```

On machines where both `~/.agents/skills` and `~/.claude/skills` are loaded,
install to the directories you actually use to avoid duplicate skill entries.

## Example: One Agent Per Project

Open separate Codex tabs, each already in the right repository:

```bash
iterm-control tab \
  --target caller \
  --command "zsh -lc 'cd /Users/me/work/backend && exec codex'"

iterm-control tab \
  --target caller \
  --command "zsh -lc 'cd /Users/me/work/frontend && exec codex'"

iterm-control tab \
  --target caller \
  --command "zsh -lc 'cd /Users/me/work/docs && exec codex'"
```

Then label them:

```bash
iterm-control badge --target session:<backend-session-id> --text "backend"
iterm-control badge --target session:<frontend-session-id> --text "frontend"
iterm-control badge --target session:<docs-session-id> --text "docs"
```

## Safety Model

The helper prefers explicit targets. Use `identify` or `list`, then operate on
`session:<id>` or `tty:<path>` for any mutating action.

`caller` resolves by TTY when possible. If an agent runtime has no TTY, the CLI
falls back to iTerm's current session and reports `caller-fallback-current` in
JSON. Treat that as user-visible focus and verify before destructive actions.

`close` has extra guardrails:

- It requires `--target`.
- It refuses `caller`, `current`, and `focused` unless `--force` is passed.
- Without `--force`, it refuses to close the current iTerm session.
- Without `--force`, it refuses to close affected sessions that are not at a
  shell prompt.

The bundle does not edit iTerm preferences or profiles.

## Requirements

- macOS
- iTerm2 with AppleScript automation permission granted to the calling terminal
  or agent runtime
- Python 3

Screenshots use the built-in `screencapture` command. Badges use iTerm's
OSC 1337 escape sequence and are written directly to the target TTY.

## Why This Exists

Terminal-native agents need more than text input. They need workspace
awareness: where am I, which pane belongs to which task, what can I safely
mutate, and how do I give the human visual proof?

This bundle packages that control layer as reusable skills instead of one-off
AppleScript snippets. It is small on purpose, but it gives agents the primitives
needed to manage iTerm like an operational workspace instead of a blind shell.
