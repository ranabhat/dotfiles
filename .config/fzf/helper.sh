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

rgv() {
# 1. Search for text in files using Ripgrep
# 2. Interactively narrow down the list using fzf
# 3. Open the file in Vim
rg --color=always --line-number --no-heading --smart-case "${*:-}" |
  fzf --ansi \
      --color "hl:-1:underline,hl+:-1:underline:reverse" \
      --delimiter : \
      --preview 'bat --color=always {1} --highlight-line {2}' \
      --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
      --bind 'enter:become(nv {1} +{2})'
      --bind 'ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down'

}

flog() {
# With "follow", preview window will automatically scroll to the bottom.
# "\033[2J" is an ANSI escape sequence for clearing the screen.
# When fzf reads this code it clears the previous preview contents.
fzf --preview-window follow --preview 'for i in $(seq 100000); do
  echo "$i"
  sleep 0.01
  (( i % 300 == 0 )) && printf "\033[2J"
done'

}
