#!/usr/bin/env bash
# List tmux sessions sorted by last accessed order (most recent first)
# and display only a session index and the session name.

# Get the list of sessions with their last attached timestamp and name.
# The format is: "<last_attached> <session_name>"
sessions=$(tmux list-sessions -F "#{session_last_attached} #{session_name}" 2>/dev/null)
if [ -z "$sessions" ]; then
  echo "No tmux sessions found."
  exit 1
fi

# Sort the sessions by the last attached timestamp (numerically, descending)
sorted_sessions=$(echo "$sessions" | sort -nr)

# Extract only the session names (second field) while preserving the sorted order.
session_names=$(echo "$sorted_sessions" | awk '{print $2}')

# Add an index to the sessions for display (session number: session name).
indexed_sessions=$(echo "$session_names" | nl -w1 -s': ')

# Let the user choose a session using fzf.
selection=$(echo "$indexed_sessions" | fzf --prompt="tmux session> " | cut -d':' -f2 | sed 's/^ *//;s/ *$//')
if [ -z "$selection" ]; then
  echo "No session selected."
  exit 1
fi

# Switch to the selected session.
tmux switch-client -t "$selection" && exit 0
