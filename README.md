# tmux-session

This repository contains a tmux plugin that provides a session picker with fzf and in-picker session actions.

The plugin now:
- includes the current session at the top
- sorts other sessions by recent activity
- shows extra context (windows count and last-used time)
- uses a Hubbamax-aligned fzf style
- binds `Ctrl-Shift-o` to open the session picker
- lets you press `Ctrl-x` inside the picker to kill the highlighted session

Add it to your tmux config with TPM:

```tmux
set -g @plugin 'afsalahamed07/tmux-session'
```

After reloading tmux or installing the plugin with TPM, these keys are available:

```text
Ctrl-Shift-o  open the session picker popup
Enter         switch to the highlighted session
Ctrl-x        kill the highlighted session

`Ctrl-x` will not kill the current session, so the popup can stay open and refresh.
```

If you are not using TPM, add equivalent bindings manually:

```tmux
bind-key -n C-S-o display-popup -w 80% -h 80% -E "~/.config/tmux/plugins/tmux-session/tmux-fzf.sh"
```
