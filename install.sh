#!/bin/bash
# ╔════════════════════════════════════════════════════════════════════════════════════╗
# ║                           🚀 ARCH DREAM MACHINE 🚀                        ║
# ║                                                                                    ║
# ║   ╭────────────────────────────────────────────────────────────────────────────╮  ║
# ║   │   ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄         │  ║
# ║   │   █   Crafted by: 𓂀 𝓓𝓻𝓮𝓪𝓶𝓬𝓸𝓭𝓮𝓻08 𓂀                                      │  ║
# ║   │   ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀         │  ║
# ║   ╰────────────────────────────────────────────────────────────────────────────╯  ║
# ║                                                                                    ║
# ╚════════════════════════════════════════════════════════════════════════════════════╝


# ═══════════════════════════════════════════════════════════════════════════════
# 🛡️ SAFETY & DEBUGGING CONFIGURATION
# ═══════════════════════════════════════════════════════════════════════════════
set -euo pipefail  # Exit on error, undefined vars, pipe failures
IFS=$'\n\t'       # Secure Internal Field Separator

# ═══════════════════════════════════════════════════════════════════════════════
# 🎨 COLOR PALETTE & STYLING (Aquarius-inspired)
# ═══════════════════════════════════════════════════════════════════════════════
readonly AQUA='\033[38;5;51m'        # Electric blue
readonly PURPLE='\033[38;5;147m'      # Lavender
readonly CYAN='\033[38;5;87m'         # Bright cyan
readonly ORANGE='\033[38;5;208m'      # Electric orange
readonly GREEN='\033[38;5;118m'       # Neon green
readonly RED='\033[38;5;196m'         # Vivid red
readonly YELLOW='\033[38;5;226m'      # Bright yellow
readonly GRAY='\033[38;5;244m'        # Cool gray
readonly BOLD='\033[1m'
readonly DIM='\033[2m'
readonly RESET='\033[0m'

# ═══════════════════════════════════════════════════════════════════════════════
# 🌟 DREAMY ANIMATION FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════════
spinner() {
    local pid=$1
    local msg=$2
    local spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local i=0
    
    while kill -0 "$pid" 2>/dev/null; do
        printf "\r${AQUA}${spin:$i:1}${RESET} ${msg}"
        i=$(((i + 1) % ${#spin}))
        sleep 0.1
    done
    printf "\r${GREEN}✓${RESET} ${msg}\n"
}

print_banner() {
    clear
    echo -e "${BOLD}${AQUA}"
    cat << 'EOF'
    ╔═══════════════════════════════════════════════════════════════════════════════╗
    ║                    🌟 ARCH LINUX DREAM SETUP 🌟                              ║
    ║                                                                               ║
    ║  ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄  ║
    ║  █ Innovative • Creative • Rebellious • Aquarius Spirit █                    ║
    ║  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀  ║
    ║                                                                               ║
    ║  Created with 💙 by: *dreamcoder08*                                           ║
    ║  Birth: February 8, 2006 🌊                                                   ║
    ║  Arch Philosophy: "Stay hungry, stay foolish, stay minimal"                   ║
    ╚═══════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${RESET}"
}

log_info() {
    echo -e "${CYAN}[INFO]${RESET} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${RESET} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${RESET} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${RESET} $1"
}

log_dream() {
    echo -e "${PURPLE}[DREAM]${RESET} $1"
}

# ═══════════════════════════════════════════════════════════════════════════════
# 🔧 SYSTEM CONFIGURATION
# ═══════════════════════════════════════════════════════════════════════════════
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly CONFIG_DIR="${SCRIPT_DIR}"
readonly BACKUP_DIR="${HOME}/.config_backup_$(date +%Y%m%d_%H%M%S)"
readonly LOG_FILE="${SCRIPT_DIR}/install_$(date +%Y%m%d_%H%M%S).log"

# Package arrays for better organization
readonly CORE_PACKAGES=(
    "zsh" "git" "curl" "wget" "neovim" "fastfetch"
    "fzf" "fd" "bat" "eza" "ripgrep" "jq" "lsof"
)

readonly MODERN_TOOLS=(
    "zsh-autosuggestions" "zsh-syntax-highlighting" "zsh-completions"
    "thefuck" "duf" "dust" "btop" "xh" "starship"
)

readonly AUR_PACKAGES=(
    "git-delta-git"
    "nvm"
)

# ═══════════════════════════════════════════════════════════════════════════════
# 🛠️ UTILITY FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════════
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

is_arch_linux() {
    [[ -f /etc/arch-release ]] || [[ -f /etc/os-release && $(grep -E "^ID=" /etc/os-release | cut -d= -f2 | tr -d '"') == "arch" ]]
}

has_sudo() {
    command_exists sudo && sudo -n true 2>/dev/null
}

get_available_cores() {
    nproc 2>/dev/null || echo "1"
}

create_backup() {
    local file="$1"
    if [[ -f "$file" || -d "$file" ]]; then
        log_info "Backing up: $file"
        mkdir -p "$BACKUP_DIR"
        cp -r "$file" "$BACKUP_DIR/"
    fi
}

# ═══════════════════════════════════════════════════════════════════════════════
# 🎯 MAIN INSTALLATION FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════════
check_prerequisites() {
    log_info "Checking system prerequisites..."
    
    if ! is_arch_linux; then
        log_error "This script is optimized for Arch Linux. Other distributions may not work correctly."
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        [[ ! $REPLY =~ ^[Yy]$ ]] && exit 1
    fi
    
    if ! has_sudo; then
        log_error "This script requires sudo privileges. Please run 'sudo -v' first."
        exit 1
    fi
    
    log_success "Prerequisites check passed!"
}

install_arch_packages() {
    local packages=("$@")
    local failed_packages=()
    
    log_info "Installing ${#packages[@]} packages via pacman..."
    
    # Update package database
    if ! sudo pacman -Sy --noconfirm; then
        log_error "Failed to update package database"
        return 1
    fi
    
    # Install packages individually to catch failures
    for package in "${packages[@]}"; do
        if ! sudo pacman -S --noconfirm --needed "$package" 2>>"$LOG_FILE"; then
            failed_packages+=("$package")
            log_warn "Failed to install: $package"
        fi
    done
    
    if [[ ${#failed_packages[@]} -gt 0 ]]; then
        log_warn "Failed packages: ${failed_packages[*]}"
        return 1
    fi
    
    log_success "All packages installed successfully!"
}

install_aur_helper() {
    if command_exists yay; then
        log_info "yay is already installed"
        return 0
    fi
    
    log_info "Installing yay AUR helper..."
    
    local temp_dir
    temp_dir=$(mktemp -d)
    
    (
        cd "$temp_dir"
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
    ) &
    
    spinner $! "Installing yay AUR helper"
    
    if command_exists yay; then
        log_success "yay installed successfully!"
        rm -rf "$temp_dir"
        return 0
    else
        log_error "Failed to install yay"
        rm -rf "$temp_dir"
        return 1
    fi
}

install_aur_packages() {
    local packages=("$@")
    
    if ! command_exists yay; then
        log_warn "yay not found, skipping AUR packages"
        return 0
    fi
    
    log_info "Installing AUR packages..."
    
    for package in "${packages[@]}"; do
        if ! yay -S --noconfirm "$package" 2>>"$LOG_FILE"; then
            log_warn "Failed to install AUR package: $package"
        fi
    done
    
    log_success "AUR packages installation completed!"
}

setup_zsh_framework() {
    log_info "Setting up Zsh framework..."
    
    # Install Oh My Zsh
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        log_info "Installing Oh My Zsh..."
        (
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        ) &
        spinner $! "Installing Oh My Zsh"
    else
        log_info "Oh My Zsh already installed"
    fi
    
    # Install Powerlevel10k
    local p10k_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    if [[ ! -d "$p10k_dir" ]]; then
        log_info "Installing Powerlevel10k..."
        (
            git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k_dir"
        ) &
        spinner $! "Installing Powerlevel10k"
    else
        log_info "Powerlevel10k already installed"
    fi
    
    log_success "Zsh framework setup completed!"
}

setup_nodejs() {
    if [[ -d "$HOME/.nvm" ]]; then
        log_info "NVM already installed"
        return 0
    fi
    
    log_info "Installing NVM (Node Version Manager)..."
    (
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
    ) &
    spinner $! "Installing NVM"
    
    # Source NVM and install latest LTS Node
    if [[ -f "$HOME/.nvm/nvm.sh" ]]; then
        source "$HOME/.nvm/nvm.sh"
        nvm install --lts
        nvm use --lts
        log_success "NVM and Node.js LTS installed!"
    else
        log_warn "NVM installation may have failed"
    fi
}

create_config_links() {
    log_info "Creating configuration symlinks..."
    
    # Backup existing configurations
    create_backup "$HOME/.zshrc"
    create_backup "$HOME/.p10k.zsh"
    create_backup "$HOME/.config/fastfetch"
    
    # Create necessary directories
    mkdir -p "$HOME/.config"
    mkdir -p "$HOME/.config/zshrc"
    
    # Create symlinks
    if [[ -f "$CONFIG_DIR/zshrc.template" ]]; then
        ln -sf "$CONFIG_DIR/zshrc.template" "$HOME/.zshrc"
        log_success "Created .zshrc symlink"
    else
        log_warn "zshrc.template not found"
    fi
    
    if [[ -f "$CONFIG_DIR/p10k.zsh.template" ]]; then
        ln -sf "$CONFIG_DIR/p10k.zsh.template" "$HOME/.p10k.zsh"
        log_success "Created .p10k.zsh symlink"
    else
        log_warn "p10k.zsh.template not found"
    fi
    
    if [[ -d "$CONFIG_DIR/fastfetch" ]]; then
        ln -sfn "$CONFIG_DIR/fastfetch" "$HOME/.config/fastfetch"
        log_success "Created fastfetch config symlink"
    else
        log_warn "fastfetch config directory not found"
    fi
}

optimize_zsh() {
    log_info "Optimizing Zsh configuration..."
    
    # Enable zsh-completions
    if [[ -f "$HOME/.zshrc" ]]; then
        echo "autoload -U compinit && compinit" >> "$HOME/.zshrc"
        log_success "Enabled zsh-completions"
    fi
    
    # Set Zsh as default shell
    if [[ "$SHELL" != "$(which zsh)" ]]; then
        log_info "Setting Zsh as default shell..."
        chsh -s "$(which zsh)"
        log_success "Default shell changed to Zsh"
    fi
}

# ═══════════════════════════════════════════════════════════════════════════════
# 🎪 MAIN EXECUTION FLOW
# ═══════════════════════════════════════════════════════════════════════════════
main() {
    # Initialize logging
    exec 1> >(tee -a "$LOG_FILE")
    exec 2> >(tee -a "$LOG_FILE" >&2)
    
    print_banner
    
    log_dream "Starting the Arch Linux Dream Setup..."
    log_info "Log file: $LOG_FILE"
    
    # Main installation steps
    check_prerequisites
    
    log_info "Installing core packages..."
    install_arch_packages "${CORE_PACKAGES[@]}"
    
    log_info "Installing modern tools..."
    install_arch_packages "${MODERN_TOOLS[@]}"
    
    install_aur_helper
    install_aur_packages "${AUR_PACKAGES[@]}"
    
    setup_zsh_framework
    setup_nodejs
    create_config_links
    optimize_zsh
    
    # Final success message
    echo -e "\n${BOLD}${GREEN}"
    cat << 'EOF'
    ╔═══════════════════════════════════════════════════════════════════════════════╗
    ║                         🎉 INSTALLATION COMPLETE! 🎉                         ║
    ║                                                                               ║
    ║  Your Arch Linux system has been transformed with the power of innovation!    ║
    ║                                                                               ║
    ║  🌟 What's been installed:                                                    ║
    ║   • Modern terminal tools (eza, bat, ripgrep, fd, etc.)                      ║
    ║   • Zsh with Oh My Zsh + Powerlevel10k                                       ║
    ║   • Node.js via NVM                                                          ║
    ║   • Optimized configurations                                                 ║
    ║                                                                               ║
    ║  🚀 Next steps:                                                               ║
    ║   1. Restart your terminal or run: source ~/.zshrc                           ║
    ║   2. Configure Powerlevel10k: p10k configure                                 ║
    ║   3. Enjoy your new Aquarius-powered setup!                                  ║
    ║                                                                               ║
    ║  Created with 💙 by: *dreamcoder08*                                           ║
    ║  "The future belongs to those who believe in the beauty of their dreams"     ║
    ╚═══════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${RESET}"
    
    log_dream "May your terminal be as infinite as the Aquarius sky! 🌊✨"
    
    # Backup information
    if [[ -d "$BACKUP_DIR" ]]; then
        log_info "Backups saved to: $BACKUP_DIR"
    fi
    
    log_info "Installation log saved to: $LOG_FILE"
}

# ═══════════════════════════════════════════════════════════════════════════════
# 🔥 SCRIPT EXECUTION
# ═══════════════════════════════════════════════════════════════════════════════
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# 🌟 *dreamcoder08* - February 8, 2006 🌊
# "Innovation distinguishes between a leader and a follower" - Steve Jobs
# ═══════════════════════════════════════════════════════════════════════════════