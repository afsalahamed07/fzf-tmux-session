#!/usr/bin/env bash
# List tmux sessions sorted by last accessed order (most recent first)
# and show only a session index and the session name,
# excluding the session currently in use.

# Get the current session name.
current_session=$(tmux display-message -p '#S')

# Get the list of sessions with last attached timestamp and name.
# Format: "<last_attached> <session_name>"
sessions=$(tmux list-sessions -F "#{session_last_attached} #{session_name}" 2>/dev/null)
if [ -z "$sessions" ]; then
  echo "No tmux sessions found."
  exit 1
fi

# Exclude the current session from the list.
sessions_filtered=$(echo "$sessions" | awk -v curr="$current_session" '$2 != curr')

# Check if there are any sessions left after filtering.
if [ -z "$sessions_filtered" ]; then
  echo "No other tmux sessions found."
  exit 1
fi

# Sort sessions by last attached time (descending) then extract the session name.
session_names=$(echo "$sessions_filtered" | sort -nr | awk '{print $2}')

# Add an index number to each session name.
indexed_sessions=$(echo "$session_names" | nl -w1 -s': ')

# Let the user choose a session using fzf.
selection=$(echo "$indexed_sessions" | fzf --prompt="tmux session> " | cut -d':' -f2 | sed 's/^ *//;s/ *$//')
if [ -z "$selection" ]; then
  echo "No session selected."
  exit 1
fi

# Switch to the selected session.
tmux switch-client -t "$selection" && exit 0
