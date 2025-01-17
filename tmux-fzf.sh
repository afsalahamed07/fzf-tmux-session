#!/usr/bin/env bash
# List tmux sessions and attach to the chosen one

sessions=$(tmux ls 2>/dev/null)
if [ -z "$sessions" ]; then
  echo "No tmux sessions found."
  exit 1
fi

selected=$(echo "$sessions" | fzf --prompt="tmux session> ")
if [ -z "$selected" ]; then
  echo "No session selected."
  exit 1
fi

# Extract the session name. Sessions are typically printed as "session_name: ...".
session_name=$(echo "$selected" | cut -d: -f1)

# Switch to the selected session.
tmux switch-client -t "$session_name" && exit 0
