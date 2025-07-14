#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

# 🎨 Colors
AQUA='\033[38;5;51m'
GREEN='\033[38;5;118m'
CYAN='\033[38;5;87m'
PURPLE='\033[38;5;147m'
YELLOW='\033[38;5;226m'
RED='\033[38;5;196m'
BOLD='\033[1m'
RESET='\033[0m'

# ✨ Spinner
spinner() {
    local pid=$1
    local msg=$2
    local spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local i=0

    tput civis
    while kill -0 "$pid" 2>/dev/null; do
        printf "\r${AQUA}${spin:i++%${#spin}:1}${RESET} ${msg}"
        sleep 0.1
    done
    printf "\r${GREEN}✓${RESET} ${msg}\n"
    tput cnorm
}

print_banner() {
    clear
    echo -e "${BOLD}${AQUA}"
    cat << 'EOF'
╔════════════════════════════════════════════════════════════════════════════╗
║                         🚀 ARCH DREAM MACHINE 🚀                           ║
║                                                                            ║
║    ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄       ║
║    █   Crafted by: 𓂀 𝓓𝓻𝓮𝓪𝓶𝓬𝓸𝓭𝓮𝓻08 𓂀                                      █       ║
║    ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀       ║
╚════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${RESET}"
}

log() { echo -e "${CYAN}[INFO]${RESET} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${RESET} $1"; }
warn() { echo -e "${YELLOW}[WARN]${RESET} $1"; }
error() { echo -e "${RED}[ERROR]${RESET} $1"; }

install_dependencies() {
    log "Checking and installing dependencies..."
    sudo pacman -S --noconfirm --needed zsh fzf fd bat eza ripgrep jq zsh-autosuggestions zsh-syntax-highlighting zsh-completions thefuck duf dust btop xh lsof curl git neovim fastfetch
}

backup_configs() {
    local BACKUP_DIR="$HOME/.config_backup_$(date +%Y%m%d_%H%M%S)"
    log "Backing up configuration to $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"
    for file in .zshrc .p10k.zsh .config/fastfetch; do
        [ -e "$HOME/$file" ] && mv "$HOME/$file" "$BACKUP_DIR/"
    done
}

setup_ohmyzsh_p10k() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        log "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
        log "Installing Powerlevel10k..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    fi
}

link_configs() {
    log "Creating symbolic links..."
    ln -sf "$CONFIG_DIR/zshrc.template" "$HOME/.zshrc"
    ln -sf "$CONFIG_DIR/p10k.zsh.template" "$HOME/.p10k.zsh"
    mkdir -p "$HOME/.config"
    ln -sfn "$CONFIG_DIR/fastfetch" "$HOME/.config/fastfetch"
}

finish_banner() {
    echo -e "${GREEN}"
    cat << 'EOF'
╔════════════════════════════════════════════════════════════════════════════╗
║                          🎉 INSTALLATION COMPLETE 🎉                       ║
║                                                                            ║
║    Crafted with 💙 by: 𓂀 𝓓𝓻𝓮𝓪𝓶𝓬𝓸𝓭𝓮𝓻08 𓂀                                       ║
╚════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${RESET}"
}

main() {
    CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    print_banner

    (install_dependencies && backup_configs && setup_ohmyzsh_p10k && link_configs) &
    spinner $! "Applying your personalized Zsh + Fastfetch setup..."

    finish_banner
    success "Setup completo. Reinicia tu terminal para aplicar los cambios."
}

main
