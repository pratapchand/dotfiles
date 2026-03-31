# Homebrew (Apple Silicon + Intel)
if [ -d /opt/homebrew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -d /usr/local/Homebrew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

# XDG directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# Dotfiles
export DOTFILES="$HOME/.dotfiles"
export PROJECTS="$HOME/dev"

# Starship config location
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"

umask 0002
