#!/bin/sh

HOME_DIR=$HOME
USER_FOLDERS=("$HOME_DIR/dev" "$HOME_DIR/go")

# Directories that are NOT stow packages (skipped by stow_packages)
_DOTFILES_INFRA=(include lib brew go vim .claude .git .github)
