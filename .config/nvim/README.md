# Neovim Configuration

<!--toc:start-->
- [Neovim Configuration](#neovim-configuration)
  - [Installation](#installation)
    - [1. System Dependencies (Required)](#1-system-dependencies-required)
    - [2. Fonts (Required)](#2-fonts-required)
    - [3. Language Toolchains (Install what you need)](#3-language-toolchains-install-what-you-need)
    - [4. Install LSP](#4-install-lsp)
    - [5. Formatter](#5-formatter)
    - [6. Linter](#6-linter)
    - [7. Debugger](#7-debugger)
    - [8. Clone and Start](#8-clone-and-start)
    - [9. Verify Installation](#9-verify-installation)
    - [10. Via Treesitter](#10-via-treesitter)
  - [Structure](#structure)
  - [Language-Specific Commands](#language-specific-commands)
    - [Go (`:help go.txt`)](#go-help-gotxt)
  - [Language Servers](#language-servers)
  - [Formatters (Conform)](#formatters-conform)
  - [Linters (nvim-lint)](#linters-nvim-lint)
  - [Health Check](#health-check)
  - [Taken Ideas from](#taken-ideas-from)
<!--toc:end-->

A minimal, fast Neovim configuration for Neovim 0.11+ with lazy-loading, LSP support.

---

## Installation

### 1. System Dependencies (Required)

```bash
# Core requirements
brew install neovim    # v0.11+ required
brew install git
brew install ripgrep   # Fast grep (used by picker)
brew install fd        # Fast find (used by picker)
brew install node      # Required for some LSPs and tools
brew install npm       # Required for some LSPs and tools
```

### 2. Fonts (Required)

Install a [Nerd Font](https://www.nerdfonts.com/) for icons:

```bash
brew install --cask font-jetbrains-mono-nerd-font
# or
brew install --cask font-fira-code-nerd-font
```

Then set your terminal to use the installed font.

### 3. Language Toolchains (Install what you need)

```bash
# Go
brew install go
# After install, run :GoInstallBinaries in nvim

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# After install, run :CargoInstallTools in nvim

```

### 4. Install LSP

We will not use mason to install: LSP, formatters, debugger and linters.

```bash
# Markdown preview (browser-based)
# markdown-preview.nvim will auto-install, but needs npm

# lua ls 
brew install lua-language-server

# bashls
npm i -g bash-language-server

# clangd
brew install llvm

# Markdown lsp
brew install marksman

# Gopls: The language server for Go
go install golang.org/x/tools/gopls@latest

# rust-analyzer
rustup component add rust-analyzer
```

### 5. Formatter

```bash
# shell bash, zsh shfmt
go install mvdan.cc/sh/v3/cmd/shfmt@latest

# json prettier
brew install prettier

# lua stylua
cargo install stylua

# python ruff
brew install ruff

# 
```

### 6. Linter

```bash
# markdown linter
brew install markdownlint-cli2
```

### 7. Debugger

```bash
# go debugger
go install github.com/go-delve/delve/cmd/dlv@latest
```

### 8. Clone and Start

```bash
# Backup existing config
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak

# Clone this config
git clone <your-repo> ~/.config/nvim

# Start Neovim - plugins will auto-install on first launch
nvim
```

### 9. Verify Installation

```vim
:checkhealth
```

All checks should pass. Common fixes:

- Missing CLI tools: `brew install <tool>`
- Treesitter errors: `:TSUpdate`
- LSP not working: `:LspInfo`

### 10. Via Treesitter

Parsers for:

1. bash
1. c
1. diff
1. html
1. lua
1. luadoc
1. markdown
1. markdown_inline
1. query
1. vim
1. vimdoc
1. rust
1. python
1. json
1. go

---

## Structure

```bash
~/.config/nvim/
.
├── .stylua.toml
├── after
│   └── ftplugin
│       ├── go.lua
│       ├── json.lua
│       ├── lua.lua
│       ├── markdown.lua
│       ├── sh.lua
│       └── typescript.lua
├── init.lua
├── lazy-lock.json
├── lsp
│   ├── bashls.lua
│   ├── clangd.lua
│   ├── gopls.lua
│   ├── lua_ls.lua
│   ├── marksman.lua
│   └── rust_analyzer.lua
├── lua
│   ├── config
│   │   ├── autocommands.lua
│   │   ├── health.lua
│   │   ├── keymaps.lua
│   │   ├── lazy.lua
│   │   └── opts.lua
│   ├── lsp.lua
│   └── plugins
│       ├── blink.lua
│       ├── conform.lua
│       ├── crates.lua
│       ├── dap-debug.lua
│       ├── fff.lua
│       ├── flash.lua
│       ├── fzf-lua.lua
│       ├── git.lua
│       ├── indent.lua
│       ├── lint.lua
│       ├── mini.lua
│       ├── notify.lua
│       ├── nvim-treesitter.lua
│       ├── oil.lua
│       ├── render-markdown.lua
│       ├── rustaceanvim.lua
│       ├── todo-comments.lua
│       ├── tokyonight.lua
│       └── which-key.lua
└── README.md
---

## Language-Specific Commands

### Go (`:help go.txt`)

| Command       | Action           |
|---------------|------------------|
| `:GoBuild`    |   go build       |
| `:GoRun`      |   go run         |
| `:GoModTidy   |   go mod tidy    |

---

## Language Servers

Server configs live under `lsp/` and are activated via `vim.lsp.enable()` in `lua/plugins/lsp.lua`.

Manually-installed:

- **Go:** gopls
- **Rust:** rust-analyzer
- **Lua:** lua_ls
- **C:** clangd
- **Bash:** bash-langguage-server
- **Markdown:** marksman

## Formatters (Conform)

| Language | Formatter |
|----------|-----------|
| Lua      | stylua    |
| JS       | prettier  |
| Shell    |  shfmt    |
| Python   |  ruff     |

Format on save is **enabled by default**.

## Linters (nvim-lint)

| Language | Linter        |
|----------|---------------|
| Markdown | markdown-cli2 |

---

## Health Check

```vim
:checkhealth
```

Common fixes:

- Missing tools: `brew install <tool>`
- Treesitter errors: `:TSUpdate`
- Go tools: `:GoInstallBinaries`
- Rust tools: `:CargoInstallTools`

---

## Taken Ideas from

- [MariaSolOs dotfiles](https://github.com/MariaSolOs/dotfiles/tree/main)
- [Aadibhanna nvim configuration](https://github.com/adibhanna/nvim)

---

Always a WIP.
