#!/usr/bin/env bash

set -euo pipefail

if ! command -v tmux >/dev/null 2>&1; then
  echo "tmux is not installed."
  exit 1
fi

if ! command -v fzf >/dev/null 2>&1; then
  echo "fzf is not installed."
  exit 1
fi

if [ -z "${TMUX:-}" ]; then
  echo "Run this inside a tmux client."
  exit 1
fi

current_session=$(tmux display-message -p '#S')
sessions_raw=$(tmux list-sessions -F "#{session_name}	#{session_last_attached}	#{session_windows}	#{?session_attached,yes,no}" 2>/dev/null || true)

if [ -z "$sessions_raw" ]; then
  echo "No tmux sessions found."
  exit 1
fi

format_time() {
  local ts="$1"
  if [ "$ts" -gt 0 ] 2>/dev/null; then
    date -r "$ts" "+%Y-%m-%d %H:%M"
  else
    printf "never"
  fi
}

build_rows() {
  local rows=""
  local others=""
  local line name ts windows attached when marker formatted

  while IFS=$'\t' read -r name ts windows attached; do
    [ -z "$name" ] && continue
    when=$(format_time "$ts")
    marker=""

    if [ "$name" = "$current_session" ]; then
      marker="current"
      formatted=$(printf "%s\t%-20s  %-7s  win:%-2s  last:%s" "$name" "$name" "$marker" "$windows" "$when")
      rows+="$formatted"$'\n'
    else
      formatted=$(printf "%s\t%s\t%s\t%s" "$name" "$ts" "$windows" "$when")
      others+="$formatted"$'\n'
    fi
  done <<<"$sessions_raw"

  if [ -n "$others" ]; then
    while IFS=$'\t' read -r name ts windows when; do
      formatted=$(printf "%s\t%-20s  %-7s  win:%-2s  last:%s" "$name" "$name" "other" "$windows" "$when")
      rows+="$formatted"$'\n'
    done <<<"$(printf "%s" "$others" | sort -t $'\t' -k2,2nr)"
  fi

  printf "%s" "$rows"
}

rows=$(build_rows)
if [ -z "$rows" ]; then
  echo "No tmux sessions found."
  exit 1
fi

selection_line=$(printf "%s" "$rows" | fzf \
  --delimiter=$'\t' \
  --with-nth=2 \
  --prompt="tmux session> " \
  --header="enter: switch session | esc: close" \
  --layout=reverse \
  --height=100% \
  --border=rounded \
  --bind='start:down' \
  --color='bg:#1c1c1c,bg+:#262626,fg:#bcbcbc,fg+:#bcbcbc,hl:#87afaf,hl+:#d7af87,prompt:#87afaf,info:#767676,pointer:#87afaf,marker:#d787d7,spinner:#87afaf,header:#9e9e9e')

if [ -z "$selection_line" ]; then
  exit 0
fi

selection=${selection_line%%$'\t'*}
tmux switch-client -t "$selection"
