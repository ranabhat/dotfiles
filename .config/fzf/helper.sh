#!/bin/zsh

# unsafe, if by mistake chosen wrong 
# process will kill it
# fkill() {
#   (
#     date
#     ps -ef
#   ) |
#     fzf --bind='ctrl-r:reload(date; ps -ef)' \
#       --header=$'Press CTRL-R to reload\n\n' --header-lines=2 \
#       --preview='echo {}' --preview-window=down,3,wrap | awk '{print $2}' | xargs kill -9
# }

# safer way
fkill() {
  local selected pids pid_list
  selected=$( (date; ps -ef) | \
    fzf --ansi --multi \
        --header=$'Press CTRL-R to reload | TAB to multi-select\n\n' \
        --header-lines=2 \
        --preview='echo {}' \
        --preview-window=down,3,wrap \
        --bind='ctrl-r:reload(date; ps -ef)'
    )

  [[ -z "$selected" ]] && return 1

  pids=$(echo "$selected" | awk '{print $2}')
  pid_list=$(echo "$pids" | tr '\n' ' ')

  echo -n "Kill PIDs: $pid_list? (y/N) "
  read -q "reply?" || return 1
  echo

  [[ "$reply" =~ ^[Yy]$ ]] || {
    echo "Aborted."
    return 1
  }

  echo "$pids" | xargs kill -9
  echo "Killed PIDs: $pid_list"
}
