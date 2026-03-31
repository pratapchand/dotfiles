#!/bin/zsh
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$DOTFILES_DIR/include/shared_vars.sh"

# -- Homebrew --
install_homebrew() {
    if ! command -v brew &>/dev/null; then
        echo "[+] Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # Ensure brew is on PATH for the rest of this script
    if [ -d /opt/homebrew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -d /usr/local/Homebrew ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi

    echo "[+] Homebrew ready"
}

# -- Brewfile --
install_brewfile() {
    echo "[+] Installing packages from Brewfile..."
    brew bundle --file="$DOTFILES_DIR/brew/Brewfile" --no-lock
    echo "[+] Packages installed"
}

# -- User directories --
create_user_dirs() {
    echo "[+] Creating user directories..."
    for dir in "${USER_FOLDERS[@]}"; do
        mkdir -p "$dir"
    done
}

# -- Stow packages --
stow_packages() {
    echo "[+] Stowing dotfile packages..."
    local skip_pattern
    skip_pattern=$(printf "|%s" "${_DOTFILES_INFRA[@]}")
    skip_pattern="${skip_pattern:1}"  # remove leading |

    for pkg_dir in "$DOTFILES_DIR"/*/; do
        pkg=$(basename "$pkg_dir")
        # Skip infrastructure directories
        if echo "$pkg" | grep -qE "^($skip_pattern)$"; then
            continue
        fi
        echo "    stow: $pkg"
        stow --dir="$DOTFILES_DIR" --target="$HOME_DIR" --restow "$pkg"
    done
    echo "[+] All packages stowed"
}

# -- SSH key --
setup_ssh() {
    if [ ! -f "$HOME_DIR/.ssh/id_ed25519" ]; then
        echo "[+] Generating SSH key..."
        mkdir -p "$HOME_DIR/.ssh"
        ssh-keygen -t ed25519 -C "$(whoami)@$(hostname)" -f "$HOME_DIR/.ssh/id_ed25519"
        echo "[+] SSH key generated. Add the public key to GitHub:"
        cat "$HOME_DIR/.ssh/id_ed25519.pub"
    else
        echo "[+] SSH key already exists"
    fi
}

# -- macOS defaults --
configure_macos() {
    echo "[+] Configuring macOS defaults..."

    # Screenshots to ~/Desktop
    defaults write com.apple.screencapture location -string "$HOME_DIR/Desktop"

    # Show hidden files in Finder
    defaults write com.apple.finder AppleShowAllFiles -bool true

    # Fast key repeat
    defaults write NSGlobalDomain KeyRepeat -int 2
    defaults write NSGlobalDomain InitialKeyRepeat -int 15

    # Disable press-and-hold for keys (enable key repeat)
    defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

    echo "[+] macOS configured (some changes need logout to take effect)"
}

# -- Main --
echo "=== dotfiles bootstrap ==="
install_homebrew
install_brewfile
create_user_dirs
stow_packages
setup_ssh
configure_macos
echo "=== Done! Open a new terminal to see changes. ==="
