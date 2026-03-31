export ZSH_DOT=~/.dotfiles

# Shell options
umask 0002
export CLICOLOR=YES
export LSCOLORS="Gxfxcxdxbxegedabagacad"

# History
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
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Editor
export EDITOR=nvim
export VISUAL=nvim

# Aliases
alias retag='ctags -f ".tags" -R --totals --exclude=tmp --exclude=log --exclude=.git . $(bundle list --paths)'

# Modern CLI replacements (with existence checks)
command -v bat &>/dev/null && alias cat='bat --plain'
command -v eza &>/dev/null && alias ls='eza' && alias ll='eza -la' && alias la='eza -a'
command -v nvim &>/dev/null && alias vim='nvim'

# direnv
eval "$(direnv hook zsh)"

# direnvwrapper
DIRENVWRAPPER_SOURCE=$DOTFILES/lib/direnvwrapper.sh
if [ -f $DIRENVWRAPPER_SOURCE ]; then
    source $DIRENVWRAPPER_SOURCE
fi

# Source all *.zsh files from dotfiles (go/path.zsh, etc.)
typeset -U config_files
config_files=($ZSH_DOT/**/*.zsh)
for file in ${(M)config_files:#*/path.zsh}; do
    source $file
done

# FZF
export FZF_DEFAULT_OPTS='--height 50% --reverse --border --inline-info'
export FZF_COMPLETION_TRIGGER='~~'
export FZF_DEFAULT_COMMAND='rg -g ""'
export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
source <(fzf --zsh) 2>/dev/null || [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Python virtual environment prompts
show_virtual_env() {
    if [[ -n "$VIRTUAL_ENV" && -n "$DIRENV_DIR" ]]; then
        echo "($(basename $VIRTUAL_ENV))"
    fi
}
PS1='$(show_virtual_env)'$PS1

# mise (language version manager)
eval "$(mise activate zsh)" 2>/dev/null

# Starship prompt (must be last)
eval "$(starship init zsh)" 2>/dev/null
