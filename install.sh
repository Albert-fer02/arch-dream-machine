#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

# 📁 Directorio base de configuración
CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOGFILE="$HOME/setup_arch_dream.log"
exec > >(tee -a "$LOGFILE") 2>&1

# 🎨 Colores
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

# 🖼️ Banner
print_banner() {
    local COLOR='\033[1;37m'  # Blanco brillante
    local RESET='\033[0m'

    [[ "${NO_CLEAR:-0}" -ne 1 ]] && clear
    echo -e "${COLOR}"
    cat << EOF
╔════════════════════════════════════════════════════════════════════════════╗
║                         🚀 ARCH DREAM MACHINE 🚀                           ║
║                                                                            ║
║    ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄        ║
║    █   Crafted by: 𓂀 𝓓𝓻𝓮𝓪𝓶𝓬𝓸𝓭𝓮𝓻08 𓂀                              █        ║
║    ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀        ║
╚════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${RESET}"
}



# 📢 Logs
log() { echo -e "${CYAN}[INFO]${RESET} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${RESET} $1"; }
warn() { echo -e "${YELLOW}[WARN]${RESET} $1"; }
error() { echo -e "${RED}[ERROR]${RESET} $1"; }

# 📦 Verificar si pacman existe
check_pacman() {
    if ! command -v pacman &>/dev/null; then
        error "Este script requiere pacman (Arch Linux o derivado). Abortando."
        exit 1
    fi
}

# 📦 Instalar dependencias
install_dependencies() {
    log "Verificando e instalando dependencias necesarias..."
    local packages=(
        zsh fzf fd bat eza ripgrep jq zsh-autosuggestions
        zsh-syntax-highlighting zsh-completions thefuck
        duf dust btop xh lsof curl git neovim fastfetch
    )

    for pkg in "${packages[@]}"; do
        if ! pacman -Q "$pkg" &>/dev/null; then
            log "Instalando: $pkg"
            sudo pacman -S --noconfirm --needed "$pkg"
        else
            success "$pkg ya está instalado."
        fi
    done
}

# 🗂️ Backup
backup_configs() {
    local BACKUP_DIR="$HOME/.config_backup_$(date +%Y%m%d_%H%M%S)"
    log "Respaldando configuraciones en: $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"
    for file in .zshrc .p10k.zsh .config/fastfetch; do
        if [ -e "$HOME/$file" ]; then
            mv "$HOME/$file" "$BACKUP_DIR/"
            success "Respaldo de $file realizado."
        fi
    done
}

# ⚡ Oh My Zsh + Powerlevel10k
setup_ohmyzsh_p10k() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        log "Instalando Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || {
            error "Fallo en la instalación de Oh My Zsh."
            exit 1
        }
    else
        success "Oh My Zsh ya está instalado."
    fi

    local theme_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    if [ ! -d "$theme_dir" ]; then
        log "Instalando Powerlevel10k..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$theme_dir" || {
            error "Fallo al clonar Powerlevel10k."
            exit 1
        }
    else
        success "Powerlevel10k ya está instalado."
    fi
}

# 🔗 Symlinks
link_configs() {
    log "Creando enlaces simbólicos..."
    # Zsh & Powerlevel10k
    ln -sf "$CONFIG_DIR/zshrc.template" "$HOME/.zshrc" || warn "Fallo al enlazar .zshrc"
    ln -sf "$CONFIG_DIR/p10k.zsh.template" "$HOME/.p10k.zsh" || warn "Fallo al enlazar .p10k.zsh"
    
    # Bash fallback
    ln -sf "$CONFIG_DIR/bashrc.template" "$HOME/.bashrc" || warn "Fallo al enlazar .bashrc"
    
    # Fastfetch & Kitty
    mkdir -p "$HOME/.config"
    ln -sfn "$CONFIG_DIR/fastfetch" "$HOME/.config/fastfetch" || warn "Fallo al enlazar fastfetch"
    ln -sfn "$CONFIG_DIR/kitty" "$HOME/.config/kitty" || warn "Fallo al enlazar kitty"

    # Nano
    mkdir -p "$HOME/.nano/backups" || warn "Fallo al crear directorio de backups de Nano"
    ln -sf "$CONFIG_DIR/nano_custom/nanorc.conf" "$HOME/.nanorc" || warn "Fallo al enlazar .nanorc"
    
    # Configuración de root (para sudo su)
    log "Configurando entorno de root..."
    if sudo test -w /root 2>/dev/null; then
        # Configurar Oh My Zsh para root
        if [ ! -d "/root/.oh-my-zsh" ]; then
            log "Instalando Oh My Zsh para root..."
            sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended 2>/dev/null || warn "⚠ No se pudo instalar Oh My Zsh para root"
        fi
        
        # Instalar Powerlevel10k para root
        if [ ! -d "/root/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
            log "Instalando Powerlevel10k para root..."
            sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "/root/.oh-my-zsh/custom/themes/powerlevel10k" 2>/dev/null || warn "⚠ No se pudo instalar Powerlevel10k para root"
        fi
        
        # Enlaces simbólicos para root
        sudo ln -sf "$CONFIG_DIR/zshrc.template" "/root/.zshrc" 2>/dev/null && success "✓ Root .zshrc enlazado" || warn "⚠ No se pudo enlazar .zshrc de root"
        sudo ln -sf "$CONFIG_DIR/p10k.zsh.template" "/root/.p10k.zsh" 2>/dev/null && success "✓ Root .p10k.zsh enlazado" || warn "⚠ No se pudo enlazar .p10k.zsh de root"
        sudo ln -sf "$CONFIG_DIR/bashrc.template" "/root/.bashrc" 2>/dev/null && success "✓ Root .bashrc enlazado" || warn "⚠ No se pudo enlazar .bashrc de root"
        
        # Configurar directorios necesarios para root
        sudo mkdir -p "/root/.config" 2>/dev/null
        sudo ln -sfn "$CONFIG_DIR/fastfetch" "/root/.config/fastfetch" 2>/dev/null && success "✓ Root fastfetch enlazado" || warn "⚠ No se pudo enlazar fastfetch de root"
        sudo ln -sfn "$CONFIG_DIR/kitty" "/root/.config/kitty" 2>/dev/null && success "✓ Root kitty enlazado" || warn "⚠ No se pudo enlazar kitty de root"
        
        # Asegurar que root tenga Zsh como shell
        if command -v zsh &>/dev/null; then
            if [[ "$(sudo cat /etc/passwd | grep "^root:" | cut -d: -f7)" != "/usr/bin/zsh" ]]; then
                log "Cambiando shell de root a Zsh..."
                sudo chsh -s /usr/bin/zsh root 2>/dev/null && success "✓ Shell de root cambiado a Zsh" || warn "⚠ No se pudo cambiar shell de root"
            else
                success "✓ Root ya usa Zsh"
            fi
        fi
        
        success "✓ Configuración de root completada"
    else
        warn "⚠ No se puede acceder al directorio de root. Configuración de root omitida."
    fi
}

# 🎊 Final
finish_banner() {
    local COLOR='\033[1;37m'  # Blanco brillante
    local RESET='\033[0m'

    echo -e "${COLOR}"
    cat << EOF
╔════════════════════════════════════════════════════════════════════════════╗
║                          🎉 INSTALLATION COMPLETE 🎉                       ║
║                                                                            ║
║    Crafted with 💙 by: 𓂀 𝓓𝓻𝓮𝓪𝓶𝓬𝓸𝓭𝓮𝓻08 𓂀                                   ║
╚════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${RESET}"
}



# 🏁 Main
main() {
    print_banner
    check_pacman

    (install_dependencies && backup_configs && setup_ohmyzsh_p10k && link_configs) &
    spinner $! "Aplicando tu configuración personalizada de Zsh + Fastfetch..."

    finish_banner
    success "Setup completo. Reinicia tu terminal para aplicar los cambios."
}

main
