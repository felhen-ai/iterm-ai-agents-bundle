# iTerm Control Recipes

## Open a 2x2 Codex Grid

```bash
iterm-control grid \
  --target caller \
  --rows 2 \
  --cols 2 \
  --command "zsh -lc 'cd /Users/me/project && exec codex'"
```

If interactive `codex` rejects an option, remove it. For example,
`--skip-git-repo-check` belongs to `codex exec`, not to the interactive `codex`
command.

## Open Project Codex Tabs

```bash
iterm-control tab \
  --target caller \
  --command "zsh -lc 'cd /Users/me/project && exec codex'"
```

Use `--profile default` to force the default iTerm profile. The default
`--profile same` copies the target session's profile into the new tab.

## Open a Separate Project Window

```bash
iterm-control window \
  --target caller \
  --command "zsh -lc 'cd /Users/me/other-project && exec codex'"
```

Use windows when the work should be visually separate from the caller's tab. As
with `tab`, `--profile same` is the default and copies the target session's
iTerm profile.

## Focus a Known Worker

```bash
iterm-control focus --target session:<id>
iterm-control focus --target tty:/dev/ttys005
```

The helper selects the target window, tab, and session. Prefer explicit session
or TTY targets after `list` or `identify`.

## Badge Panes

```bash
iterm-control badge --target caller --text "main"
iterm-control badge --target session:<id> --text "worker-1"
iterm-control badge --target tty:/dev/ttys005 --text "logs"
```

The helper writes `OSC 1337;SetBadgeFormat=<base64>` directly to the target TTY.

## Send Commands

```bash
iterm-control send --target session:<id> --text "git status"
iterm-control send --target tty:/dev/ttys005 --text "npm test"
```

Use `--no-newline` only for low-level input. It writes directly to the TTY.

## Close Temporary Sessions

```bash
iterm-control close --target session:<id> --scope session
iterm-control close --target session:<id> --scope tab --force
iterm-control close --target session:<id> --scope window --force
```

Without `--force`, `close` refuses to close `caller`, `current`, `focused`, the
current iTerm session, or any affected session that is not at the shell prompt.
Use `--force` only when the exact scope is intentional, for example test windows
created by the same automation run.

## Health Check

```bash
iterm-control health
```

`health` reports window/tab/session counts, caller targeting resolution, current
session, and warnings such as `caller-fallback-current` or sessions not at a
shell prompt.

## Visual Proof

```bash
iterm-control screenshot --output /tmp/iterm-layout.png
```

Inspect the image when layout, badges, or full-screen TUI state matters.
