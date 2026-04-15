export ZSH_DOT=~/.dotfiles
export PATH="/opt/homebrew/bin:/opt/homebrew/opt/ruby/bin:$PATH"

# Shell options
umask 0002
export CLICOLOR=YES
export LSCOLORS="Gxfxcxdxbxegedabagacad"

# Editor
export EDITOR=nvim
export VISUAL=nvim

# History
setopt EXTENDED_HISTORY
setopt inc_append_history_time
setopt histignorealldups sharehistory
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# Auto-completion
autoload -Uz compinit
compinit -u
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Source all *.zsh files from dotfiles (go/path.zsh, etc.)
typeset -U config_files
config_files=($ZSH_DOT/**/*.zsh)
for file in ${(M)config_files:#*/path.zsh}; do
    source $file
done

# FZF
source <(fzf --zsh) 2>/dev/null || [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='--height 50% --reverse --border --inline-info'
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_COMPLETION_TRIGGER='~~'
export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

# Aliases
alias retag='ctags -f ".tags" -R --totals --exclude=tmp --exclude=log --exclude=.git . $(bundle list --paths)'

# mise (language version manager)
eval "$(mise activate zsh)" 2>/dev/null
eval "$(starship init zsh)" 2>/dev/null
eval "$(/usr/libexec/path_helper)" 2>/dev/null

# Project management commands (misewrapper)
MISEWRAPPER_SOURCE="${DOTFILES}/lib/misewrapper.sh"
[[ -f ${MISEWRAPPER_SOURCE} ]] && source ${MISEWRAPPER_SOURCE}

# Aliases (interactive shell only)
alias_if_exists() {
  command -v "$2" &> /dev/null && alias "$1"="$2"
}

if [[ -o interactive ]]; then
    eval "$(zoxide init zsh --cmd cd)"
    alias_if_exists cat bat
    alias_if_exists top htop
    alias_if_exists grep rg
    alias_if_exists ls eza
    alias_if_exists time hyperfine
    alias_if_exists vim nvim
    alias brewup='brew update && brew upgrade && brew bundle upgrade'

    function y() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
        command yazi "$@" --cwd-file="$tmp"
        IFS= read -r -d '' cwd < "$tmp"
        [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
        rm -f -- "$tmp"
    }
fi
