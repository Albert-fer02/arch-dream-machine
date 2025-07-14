#!/bin/bash

# install.sh

# Exit immediately if a command exits with a non-zero status.
set -e

# Variables
CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.config_backup_$(date +%Y%m%d_%H%M%S)"

# Functions
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Detect OS
get_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
    else
        OS=$(uname -s)
    fi
    echo "$OS"
}

# Install dependencies
install_dependencies() {
    echo "Checking and installing dependencies..."
    OS=$(get_os)

    if [ "$OS" = "arch" ]; then
        echo "Detected Arch Linux. Installing dependencies with pacman..."
        # Check for sudo
        if ! command_exists sudo; then
            echo "Error: sudo is not installed. Please install it first."
            exit 1
        fi
        # Install all dependencies using pacman --needed
        sudo pacman -S --noconfirm --needed zsh fzf fd bat eza ripgrep jq zsh-autosuggestions zsh-syntax-highlighting zsh-completions thefuck duf dust btop delta xh lsof curl git neovim fastfetch
        echo "All pacman dependencies are satisfied."
    else
        echo "Checking for required commands..."
        REQUIRED_CMDS="zsh git fastfetch fzf fd bat eza rg jq thefuck duf dust btop delta xh lsof curl nvim"
        for cmd in $REQUIRED_CMDS; do
            if ! command_exists "$cmd"; then
                echo "Error: $cmd is not installed. Please install it on your system."
                exit 1
            fi
        done
        echo "All commands are satisfied."
    fi

    # Install NVM separately if not already installed
    if ! command_exists nvm; then
        echo "Installing NVM (Node Version Manager)..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
        # Source nvm for the current session to make 'nvm' command available immediately
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
        echo "NVM installed."
    else
        echo "NVM is already installed."
    fi
}


# Create backups
create_backups() {
    echo "Creating backups of existing configuration files..."
    mkdir -p "$BACKUP_DIR"
    mv -f "$HOME/.zshrc" "$BACKUP_DIR/" 2>/dev/null || true
    mv -f "$HOME/.p10k.zsh" "$BACKUP_DIR/" 2>/dev/null || true
    mv -f "$HOME/.config/fastfetch" "$BACKUP_DIR/" 2>/dev/null || true
    echo "Backups created in $BACKUP_DIR"
}

# Install Oh My Zsh and Powerlevel10k
install_oh_my_zsh_and_p10k() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        echo "Oh My Zsh is already installed."
    fi

    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
        echo "Installing Powerlevel10k..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    else
        echo "Powerlevel10k is already installed."
    fi
}

# Create symbolic links
create_symlinks() {
    echo "Creating symbolic links..."
    ln -sf "$CONFIG_DIR/zshrc.template" "$HOME/.zshrc"
    ln -sf "$CONFIG_DIR/p10k.zsh.template" "$HOME/.p10k.zsh"
    mkdir -p "$HOME/.config"
    ln -sfn "$CONFIG_DIR/fastfetch" "$HOME/.config/fastfetch"
    echo "Symbolic links created."
}

# Main
main() {
    install_dependencies
    create_backups
    install_oh_my_zsh_and_p10k
    create_symlinks
    echo "Installation complete! Please restart your shell."
}

main
