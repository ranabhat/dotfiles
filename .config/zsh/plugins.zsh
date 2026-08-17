# Completion system
ZPLUGINDIR="${ZDOTDIR:-$HOME/.config/zsh}/plugins"

_zplugin_load() {
  local owner="$1"
  local repo="$2"
  local file="$3"
  local plugin_path="${ZPLUGINDIR}/${repo}"

  if [[ ! -d "$plugin_path" ]]; then
    mkdir -p "$ZPLUGINDIR"
    echo "Installing ${repo}..."
    git clone --depth=1 "https://github.com/${owner}/${repo}" "$plugin_path" \
      || { echo "ERROR: failed to install ${repo}" >&2; return 1; }
  fi

  if [[ -z "$file" ]]; then
    file="${repo}.plugin.zsh"
  fi

  source "${plugin_path}/${file}"
}

zplugin-update() {
  local dir

  for dir in "${ZPLUGINDIR}"/*/; do
    echo "Updating ${dir:t}..."
    git -C "$dir" pull --ff-only
  done
}

   # Load plugins
_zplugin_load zsh-users zsh-autosuggestions zsh-autosuggestions.zsh
_zplugin_load jeffreytse zsh-vi-mode zsh-vi-mode.plugin.zsh
_zplugin_load zdharma-continuum fast-syntax-highlighting fast-syntax-highlighting.plugin.zsh

# Keep syntax highlighting near the end of plugin loading.
# _zplugin_load zsh-users zsh-syntax-highlighting zsh-syntax-highlighting.zsh
