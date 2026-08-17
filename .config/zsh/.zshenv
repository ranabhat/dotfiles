#!/bin/zsh

export ZDOTDIR=${ZDOTDIR:-$HOME/.config/zsh}

# XDG
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}

export XDG_RUNTIME_DIR="$TMPDIR/xdg_runtime"
# Ensure Zsh directories exist.
() {
  local zdir
  for zdir in $@; do
    [[ -d "${(P)zdir}" ]] || mkdir -p -- "${(P)zdir}"
  done
} XDG_{CONFIG,CACHE,DATA,STATE}_HOME

export EDITOR="nvim"
export VISUAL="nvim"

# ---------- GPG ----------
export GPG_TTY=$(tty)

