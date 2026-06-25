# macOS Permissions

iTerm control may require these permissions, depending on the command:

- Automation: terminal app or agent runner controlling iTerm through AppleScript.
- Accessibility: needed only for UI-level keystrokes, which this bundle avoids by default.
- Screen Recording: needed for `screencapture` to capture the iTerm window.

The default diagnostic does not read pane contents and does not change UI state.
`--test-badge` is the only visible diagnostic action.
