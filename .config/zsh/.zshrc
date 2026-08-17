# Deduplicate PATH entries
typeset -U path PATH

path=(
	/opt/homebrew/bin
	$HOME/.local/bin
	$HOME/bin
	$HOME/.cargo/bin
	$HOME/.opencode/bin
	$HOME/go/bin
	$path
)

# Custom rustup completions
[ -d "$ZDOTDIR/completions" ] && fpath=("$ZDOTDIR/completions" $fpath)

# Completion system
autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump"

 [ -f "$ZDOTDIR/plugins.zsh" ] && source "$ZDOTDIR/plugins.zsh"
# Local aliases
[ -f "$ZDOTDIR/aliases.zsh" ] && source "$ZDOTDIR/aliases.zsh"

# fzf
if command -v fzf >/dev/null 2>&1; then
	source <(fzf --zsh)
fi

[ -f "$XDG_CONFIG_HOME/fzf/fzfrc" ] && source "$XDG_CONFIG_HOME/fzf/fzfrc"
[ -f "$XDG_CONFIG_HOME/fzf/helper.sh" ] && source "$XDG_CONFIG_HOME/fzf/helper.sh"

# Tool hooks
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"
# command -v thefuck >/dev/null 2>&1 && eval "$(thefuck --alias)"
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

# Cargo env
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# Bun
export BUN_INSTALL="$HOME/.bun"
path=("$BUN_INSTALL/bin" $path)

# Lazy Loading nvm
export NVM_DIR="$HOME/.config/nvm"

load-nvm() {
	unset -f nvm node npm npx yarn pnpm corepack pi load-nvm

	[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
	[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
}

nvm() {
	load-nvm
	nvm "$@"
}

node() {
	load-nvm
	node "$@"
}

npm() {
	load-nvm
	npm "$@"
}

npx() {
	load-nvm
	npx "$@"
}

yarn() {
	load-nvm
	yarn "$@"
}

pnpm() {
	load-nvm
	pnpm "$@"
}

corepack() {
	load-nvm
	corepack "$@"
}

pi() {
	load-nvm
	pi "$@"
}

# uv/env file
[ -f "$HOME/.local/bin/env" ] && source "$HOME/.local/bin/env"

# Editor helper
_have() {
	command -v "$1" >/dev/null 2>&1
}

set-editor() {
	export EDITOR="$1"
	export VISUAL="$1"
	export GH_EDITOR="$1"
	export GIT_EDITOR="$1"
	alias vi="$EDITOR"
}

_have vim && set-editor vim
_have nvim && set-editor nvim

# Yazi cd helper
y() {
	local tmp cwd

	tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"

	IFS= read -r -d '' cwd <"$tmp"

	if [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi

	rm -f -- "$tmp"
}

# Lazygit cd helper
lg() {
	export LAZYGIT_NEW_DIR_FILE="$HOME/.lazygit/newdir"

	lazygit "$@"

	if [ -f "$LAZYGIT_NEW_DIR_FILE" ]; then
		cd "$(cat "$LAZYGIT_NEW_DIR_FILE")"
		rm -f "$LAZYGIT_NEW_DIR_FILE" >/dev/null
	fi
}

# Create a new worktree and branch from within current git directory
create_wt() {
	if [[ -z "$1" ]]; then
		echo "Usage: create_wt [branch name]"
		return 1
	fi

	local branch base worktree_path

	branch="$1"
	base="$(basename "$PWD")"
	worktree_path="../${base}--${branch}"

	git worktree add -b "$branch" "$worktree_path" || return 1
	cd "$worktree_path" || return 1
}

# Remove worktree and branch from within active worktree directory
gwd() {
	if gum confirm "Remove worktree and branch?"; then
		local cwd worktree root branch

		cwd="$(pwd)"
		worktree="$(basename "$cwd")"

		root="${worktree%%--*}"
		branch="${worktree#*--}"

		# Protect against accidentally nuking a non-worktree directory
		if [[ "$root" != "$worktree" ]]; then
			cd "../$root" || return 1
			git worktree remove "$worktree" --force
			git branch -D "$branch"
		fi
	fi
}




