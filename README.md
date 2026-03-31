# dotfiles

Personal dotfiles for macOS, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Quick Start

```bash
git clone git@github.com:pratapchand/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

This will:
- Install Homebrew and all packages from `brew/Brewfile`
- Symlink all config packages to `$HOME` via Stow
- Generate an SSH key (if missing)
- Apply macOS defaults (key repeat, hidden files, etc.)

## Revert

```bash
cd ~/.dotfiles
./revert.sh
```

Removes all Stow-managed symlinks from `$HOME`.

## Structure

```
brew/              Declarative Brewfile (packages, casks, fonts)
zsh/               .zshrc, .zshenv (standalone zsh, no oh-my-zsh)
git/               .gitconfig, .gitignore, .git_template (hooks)
tmux/              .tmux.conf + powerline themepack
direnv/            .direnvrc (custom layouts) + envrc templates
nvim/              Neovim config (lazy.nvim, LSP, Telescope, Treesitter)
starship/          Starship prompt config
go/                Go PATH setup (auto-sourced via *.zsh glob)
vim/               Legacy vim config (kept for reference, not stowed)
lib/               Shell libraries (direnvwrapper)
include/           Shared variables for install/revert scripts
```

## How Stow Works

Each top-level directory is a "stow package". The directory structure inside mirrors `$HOME`:

```
zsh/.zshrc          -> ~/.zshrc
git/.gitconfig      -> ~/.gitconfig
nvim/.config/nvim/  -> ~/.config/nvim/
starship/.config/starship/ -> ~/.config/starship/
```

Running `stow zsh` from the dotfiles directory creates the symlink. The `install.sh` script auto-discovers and stows all packages.

## Key Tools

| Tool | Purpose |
|------|---------|
| [Stow](https://www.gnu.org/software/stow/) | Symlink management |
| [Starship](https://starship.rs/) | Cross-shell prompt |
| [Neovim](https://neovim.io/) + lazy.nvim | Editor |
| [mise](https://mise.jdx.dev/) | Language version manager (replaces pyenv/rbenv/nvm) |
| [direnv](https://direnv.net/) | Per-project environments |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Fast search |

## direnv Projects

Create language-specific project environments:

```bash
mkproject myapp python3    # Python 3 venv
mkproject myapi golang     # Go project
mkproject mysite node      # Node project
workon myapp               # cd to project, activates direnv
```
