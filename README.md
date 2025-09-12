# Dotfiles Configuration

- Install GNU Stow: `brew install stow`
- Create a dotfiles directory `mkdir dotfiles`. Make sure the directory is located in your home directory.
- Move inside the directory `cd dotfiles`
- Make a git repository `git init`
- Move my configuration to this directory `mv ~/.config ./`
- Structure your dotfiles inside the dotfiles directory as you would do normally in your home directory.
- Run `stow .`. This command will do is take everything inside of the dotfiles directory and create symlink for these files into the parent which is exactly where we need these files.
- If you would like to add files that you would like to ignore, create `touch .stow-local-ignore` and add the files you would like to ignore. By default gnu ignores following
    ```
    # Comments and blank lines are allowed.

    RCS
    .+,v

    CVS
    \.\#.+       # CVS conflict files / emacs lock files
    \.cvsignore

    \.svn
    _darcs
    \.hg

    \.git
    \.gitignore
    \.gitmodules

    .+~          # emacs backup files
    \#.*\#       # emacs autosave files

    ^/README.*
    ^/LICENSE.*
    ^/COPYING
    ```

