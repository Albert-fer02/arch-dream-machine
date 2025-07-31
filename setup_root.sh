#!/bin/bash

# Simple script to set up root environment with Arch Dream Machine configuration
# Run this as: sudo ./setup_root.sh

set -e

echo "🔧 Setting up root environment with Arch Dream Machine configuration..."

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install Zsh if not already installed
if ! command -v zsh &>/dev/null; then
    echo "📦 Installing Zsh..."
    pacman -S --noconfirm zsh
fi

# Install Oh My Zsh for root if not exists
if [ ! -d "/root/.oh-my-zsh" ]; then
    echo "📦 Installing Oh My Zsh for root..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "✅ Oh My Zsh already installed for root."
fi

# Install Powerlevel10k for root
THEME_DIR="/root/.oh-my-zsh/custom/themes/powerlevel10k"
if [ ! -d "$THEME_DIR" ]; then
    echo "📦 Installing Powerlevel10k for root..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$THEME_DIR"
else
    echo "✅ Powerlevel10k already installed for root."
fi

# Create necessary directories
echo "📁 Creating directories..."
mkdir -p /root/.config /root/.nano/backups /root/.zsh

# Create symlinks for configuration files
echo "🔗 Creating configuration symlinks..."

# Backup existing files if they exist and are not symlinks
backup_if_exists() {
    local target="$1"
    local description="$2"
    
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "💾 Backing up existing $description..."
        mv "$target" "$target.backup.$(date +%Y%m%d_%H%M%S)"
    fi
}

# Backup and create symlinks
backup_if_exists "/root/.zshrc" ".zshrc"
backup_if_exists "/root/.p10k.zsh" ".p10k.zsh"
backup_if_exists "/root/.bashrc" ".bashrc"
backup_if_exists "/root/.config/fastfetch" "fastfetch"
backup_if_exists "/root/.config/kitty" "kitty"
backup_if_exists "/root/.nanorc" ".nanorc"

# Create symlinks
ln -sf "$SCRIPT_DIR/zshrc.template" "/root/.zshrc"
ln -sf "$SCRIPT_DIR/p10k.zsh.template" "/root/.p10k.zsh"
ln -sf "$SCRIPT_DIR/bashrc.template" "/root/.bashrc"
ln -sf "$SCRIPT_DIR/fastfetch" "/root/.config/fastfetch"
ln -sf "$SCRIPT_DIR/kitty" "/root/.config/kitty"
ln -sf "$SCRIPT_DIR/nano_custom/nanorc.conf" "/root/.nanorc"

# Set proper permissions
echo "🔐 Setting permissions..."
chown -R root:root /root/.config /root/.zsh /root/.oh-my-zsh 2>/dev/null || true
chmod 700 /root/.config /root/.zsh /root/.oh-my-zsh 2>/dev/null || true

# Set Zsh as default shell for root
echo "🐚 Setting Zsh as default shell for root..."
chsh -s /bin/zsh root

echo "✅ Root environment setup complete!"
echo ""
echo "🎉 You can now use 'sudo su' to switch to root with the same configuration."
echo "💡 The root environment now has:"
echo "   • Oh My Zsh + Powerlevel10k"
echo "   • Fastfetch with custom themes"
echo "   • Kitty terminal configuration"
echo "   • Nano configuration"
echo "   • Same aliases and functions as your user"
echo ""
echo "🚀 Try: sudo su" 