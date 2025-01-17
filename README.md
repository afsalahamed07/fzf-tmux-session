# tmux-session

This repository contains a simple Bash script I created to easily switch between tmux sessions. The script lists sessions (excluding the current one) sorted by last accessed time and lets you choose one via fzf.

I've also set up a shortcut in my tmux configuration:

```tmux
bind-key -n C-S-o display-popup -E "~/.config/tmux/plugins/tmux-session/tmux-fzf.sh"
```
