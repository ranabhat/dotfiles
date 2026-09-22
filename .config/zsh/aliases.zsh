command -v lazydocker >/dev/null 2>&1 && alias lzd='lazydocker'

alias l='ls -Alh'
alias revi='git rev-parse HEAD'
alias src='source "$ZDOTDIR/.zshrc"'
alias npmlist='npm list -g --depth=0'

command -v bat >/dev/null 2>&1 && alias cat='bat'

if command -v eza >/dev/null 2>&1; then
	alias ls='eza --icons=always --color=always --group-directories-first'
	alias lsl='eza -al --icons'
	alias lta='eza -lTag --icons'
	alias lta1='eza -lTag --level=1 --icons'
	alias lta2='eza -lTag --level=2 --icons'
	alias lta3='eza -lTag --level=3 --icons'
	alias lta4='eza -lTag --level=4 --icons'
fi

command -v zoxide >/dev/null 2>&1 && alias cd='z'

alias gcb="git branch | fzf --preview 'git show --color=always {-1}' \
  --bind 'enter:become(git checkout {-1})' \
  --height 40% --layout reverse"

alias lgd='DELTA_FEATURES=+side-by-side lazygit'
command -v nvim >/dev/null 2>&1 && alias vim='nvim'
