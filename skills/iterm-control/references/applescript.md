# iTerm AppleScript Notes

The helper uses iTerm's AppleScript dictionary for topology and splits:

- `windows`, `tabs`, and `sessions` enumerate layout.
- `id`, `name`, `tty`, and `is at shell prompt` identify sessions.
- `split vertically with same profile` creates a side-by-side split.
- `split horizontally with same profile` creates a below/above split.
- `write <session> text <payload>` sends text to a session.

iTerm badges are not a normal AppleScript property in current iTerm versions.
Use the iTerm escape sequence instead:

```text
ESC ] 1337 ; SetBadgeFormat=<base64 text> BEL
```

The CLI writes that sequence to the session TTY so it does not depend on the
shell process currently running in the pane.
