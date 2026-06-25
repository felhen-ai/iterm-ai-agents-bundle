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

## Visual Proof

```bash
iterm-control screenshot --output /tmp/iterm-layout.png
```

Inspect the image when layout, badges, or full-screen TUI state matters.
