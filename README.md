# tmux-session

This repository contains a Bash script to quickly switch between tmux sessions with fzf.

The picker now:
- includes the current session at the top
- sorts other sessions by recent activity
- shows extra context (windows count and last-used time)
- uses a Hubbamax-aligned fzf style

I've also set up a shortcut in my tmux configuration:

```tmux
bind-key -n C-S-o display-popup -w 80% -h 80% -E "~/.config/tmux/plugins/tmux-session/tmux-fzf.sh"
```
