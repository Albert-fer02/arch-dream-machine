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

# Check for dependencies
check_dependencies() {
    echo "Checking dependencies..."
    if ! command_exists zsh; then
        echo "Error: Zsh is not installed. Please install it first."
        exit 1
    fi
    if ! command_exists git; then
        echo "Error: Git is not installed. Please install it first."
        exit 1
    fi
    if ! command_exists fastfetch; then
        echo "Error: Fastfetch is not installed. Please install it first."
        exit 1
    fi
    echo "All dependencies are satisfied."
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
    check_dependencies
    create_backups
    install_oh_my_zsh_and_p10k
    create_symlinks
    echo "Installation complete! Please restart your shell."
}

main
