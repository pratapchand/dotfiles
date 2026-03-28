# dotfiles

Personal dotfiles for macOS. Manages zsh, vim, tmux, git, direnv, and Go configurations.

Originally based on [kulesh/dotfiles](https://github.com/kulesh/dotfiles).

## Install

```bash
git clone git@github.com:pratapchand/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

This will:
- Install Homebrew and CLI tools
- Install oh-my-zsh
- Install Janus (vim distribution)
- Back up existing dotfiles to `~/.dotbackup/`
- Symlink all `*.sl` files to `~/.*` (e.g. `zsh/zshrc.sl` -> `~/.zshrc`)

## Revert

```bash
cd ~/.dotfiles
./revert.sh
```

Removes symlinks and restores the most recent backup from `~/.dotbackup/`.

## Structure

```
include/          Shared variables (paths, extensions)
install.sh        Full setup: brew, zsh, vim, symlinks
revert.sh         Undo symlinks and restore backups
lib/              Shell libraries (direnvwrapper)
direnv/           direnvrc + envrc templates per language
git/              gitconfig, gitignore, git hooks template
zsh/              zshrc, zshenv
vim/              vimrc, before/after configs, solarized theme
tmux/             tmux.conf, powerline themepack
go/               Go path setup (auto-sourced via *.zsh glob)
```

## Symlink Convention

Files ending in `.sl` are symlinked to `$HOME` with a dot prefix:
- `zsh/zshrc.sl` -> `~/.zshrc`
- `git/gitconfig.sl` -> `~/.gitconfig`
- `vim/vimrc.sl` -> `~/.vimrc`
- `tmux/tmux.conf.sl` -> `~/.tmux.conf`
- `direnv/direnvrc.sl` -> `~/.direnvrc`

## direnv Projects

Create language-specific project environments:

```bash
mkproject myapp python3    # Python 3 venv
mkproject myapi golang     # Go with gb
mkproject mysite node      # Node with nvm
workon myapp               # cd to project, activates direnv
```
