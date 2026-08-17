# Set ZDOTDIR

ZSH need to know `ZDOTDIR` before it can find `~/.config/zsh/.zshenv`

* Add following lines to `/etc/zshenv`

```zsh
 if [[ ! -o norcs ]]; then
   export ZDOTDIR="$HOME/.config/zsh"
 fi
```
