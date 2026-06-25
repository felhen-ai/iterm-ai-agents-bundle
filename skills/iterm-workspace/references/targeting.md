# iTerm Targeting Model

iTerm exposes sessions, not cmux-style surfaces. The stable identifiers are:

- Session id: iTerm GUID, stable for the life of the session.
- TTY path: Unix terminal path, for example `/dev/ttys003`.
- Current session: iTerm's focused session in the current window.

Agents often run tool commands without a real TTY. In that case `caller` cannot
always be matched by TTY. The helper reports this as `caller-fallback-current`.

Recommended target flow:

1. Run `iterm-control identify`.
2. If `resolved_caller.resolution` is `caller-tty`, using `caller` is safe.
3. Otherwise run `iterm-control list` and select `session:<id>` or `tty:<path>`.
4. Use `current` only for explicitly focus-based tasks.

Do not infer a pane by geometry. AppleScript does not provide enough stable pane
coordinates for safe routing.
