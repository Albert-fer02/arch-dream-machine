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

# 🗂️ Backup para usuario específico
backup_configs() {
    local USER_HOME="$1"
    local USER_NAME="$2"
    local BACKUP_DIR="$USER_HOME/.config_backup_$(date +%Y%m%d_%H%M%S)"
    
    log "Respaldando configuraciones de $USER_NAME en: $BACKUP_DIR"
    
    if [[ "$USER_NAME" == "root" ]]; then
        sudo mkdir -p "$BACKUP_DIR"
        for file in .zshrc .p10k.zsh .config/fastfetch; do
            if [[ -e "$USER_HOME/$file" ]]; then
                sudo mv "$USER_HOME/$file" "$BACKUP_DIR/"
                success "Respaldo de $file para $USER_NAME realizado."
            fi
        done
    else
        mkdir -p "$BACKUP_DIR"
        for file in .zshrc .p10k.zsh .config/fastfetch; do
            if [[ -e "$USER_HOME/$file" ]]; then
                mv "$USER_HOME/$file" "$BACKUP_DIR/"
                success "Respaldo de $file para $USER_NAME realizado."
            fi
        done
    fi
}

# ⚡ Oh My Zsh + Powerlevel10k para usuario específico
setup_ohmyzsh_p10k() {
    local USER_HOME="$1"
    local USER_NAME="$2"
    local IS_ROOT="$3"
    
    log "Configurando Oh My Zsh y Powerlevel10k para $USER_NAME..."
    
    if [[ "$IS_ROOT" == "true" ]]; then
        # Configuración para root
        if [[ ! -d "$USER_HOME/.oh-my-zsh" ]]; then
            log "Instalando Oh My Zsh para root..."
            sudo -u root sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || {
                error "Fallo en la instalación de Oh My Zsh para root."
                exit 1
            }
        else
            success "Oh My Zsh ya está instalado para root."
        fi

        local theme_dir="$USER_HOME/.oh-my-zsh/custom/themes/powerlevel10k"
        if [[ ! -d "$theme_dir" ]]; then
            log "Instalando Powerlevel10k para root..."
            sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$theme_dir" || {
                error "Fallo al clonar Powerlevel10k para root."
                exit 1
            }
            sudo chown -R root:root "$theme_dir"
        else
            success "Powerlevel10k ya está instalado para root."
        fi
        
        # Cambiar shell por defecto de root a zsh
        log "Cambiando shell por defecto de root a zsh..."
        sudo chsh -s /usr/bin/zsh root
        success "Shell de root cambiado a zsh."
        
    else
        # Configuración para usuario normal
        if [[ ! -d "$USER_HOME/.oh-my-zsh" ]]; then
            log "Instalando Oh My Zsh para $USER_NAME..."
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || {
                error "Fallo en la instalación de Oh My Zsh para $USER_NAME."
                exit 1
            }
        else
            success "Oh My Zsh ya está instalado para $USER_NAME."
        fi

        local theme_dir="${ZSH_CUSTOM:-$USER_HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
        if [[ ! -d "$theme_dir" ]]; then
            log "Instalando Powerlevel10k para $USER_NAME..."
            git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$theme_dir" || {
                error "Fallo al clonar Powerlevel10k para $USER_NAME."
                exit 1
            }
        else
            success "Powerlevel10k ya está instalado para $USER_NAME."
        fi
    fi
}

# 🔗 Symlinks para usuario específico
link_configs() {
    local USER_HOME="$1"
    local USER_NAME="$2"
    local IS_ROOT="$3"
    
    log "Creando enlaces simbólicos para $USER_NAME..."
    
    if [[ "$IS_ROOT" == "true" ]]; then
        # Enlaces para root
        sudo ln -sf "$CONFIG_DIR/zshrc.template" "$USER_HOME/.zshrc" || warn "Fallo al enlazar .zshrc para root"
        sudo ln -sf "$CONFIG_DIR/p10k.zsh.template" "$USER_HOME/.p10k.zsh" || warn "Fallo al enlazar .p10k.zsh para root"
        
        # Fastfetch & Kitty para root
        sudo mkdir -p "$USER_HOME/.config"
        sudo ln -sfn "$CONFIG_DIR/fastfetch" "$USER_HOME/.config/fastfetch" || warn "Fallo al enlazar fastfetch para root"
        sudo ln -sfn "$CONFIG_DIR/kitty" "$USER_HOME/.config/kitty" || warn "Fallo al enlazar kitty para root"

        # Nano para root
        sudo mkdir -p "$USER_HOME/.nano/backups" || warn "Fallo al crear directorio de backups de Nano para root"
        sudo ln -sf "$CONFIG_DIR/nano_custom/nanorc.conf" "$USER_HOME/.nanorc" || warn "Fallo al enlazar .nanorc para root"
        
        # Ajustar permisos
        sudo chown -R root:root "$USER_HOME/.config"
        sudo chown root:root "$USER_HOME/.zshrc" "$USER_HOME/.p10k.zsh" "$USER_HOME/.nanorc"
        
    else
        # Enlaces para usuario normal
        ln -sf "$CONFIG_DIR/zshrc.template" "$USER_HOME/.zshrc" || warn "Fallo al enlazar .zshrc para $USER_NAME"
        ln -sf "$CONFIG_DIR/p10k.zsh.template" "$USER_HOME/.p10k.zsh" || warn "Fallo al enlazar .p10k.zsh para $USER_NAME"
        
        # Fastfetch & Kitty para usuario normal
        mkdir -p "$USER_HOME/.config"
        ln -sfn "$CONFIG_DIR/fastfetch" "$USER_HOME/.config/fastfetch" || warn "Fallo al enlazar fastfetch para $USER_NAME"
        ln -sfn "$CONFIG_DIR/kitty" "$USER_HOME/.config/kitty" || warn "Fallo al enlazar kitty para $USER_NAME"

        # Nano para usuario normal
        mkdir -p "$USER_HOME/.nano/backups" || warn "Fallo al crear directorio de backups de Nano para $USER_NAME"
        ln -sf "$CONFIG_DIR/nano_custom/nanorc.conf" "$USER_HOME/.nanorc" || warn "Fallo al enlazar .nanorc para $USER_NAME"
    fi
    
    success "Enlaces simbólicos creados para $USER_NAME."
}

# 👤 Configurar usuario específico
setup_user() {
    local USER_HOME="$1"
    local USER_NAME="$2"
    local IS_ROOT="$3"
    
    log "=== Configurando usuario: $USER_NAME ==="
    backup_configs "$USER_HOME" "$USER_NAME"
    setup_ohmyzsh_p10k "$USER_HOME" "$USER_NAME" "$IS_ROOT"
    link_configs "$USER_HOME" "$USER_NAME" "$IS_ROOT"
    success "Configuración completada para $USER_NAME"
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
║    ✅ Usuario actual configurado                                           ║
║    ✅ Usuario root configurado                                             ║
║    ✅ Mismo entorno para ambos usuarios                                    ║
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

    log "Iniciando configuración para usuario actual y root..."
    
    # Instalar dependencias una sola vez
    install_dependencies

    # Configurar usuario actual
    setup_user "$HOME" "$(whoami)" "false"
    
    # Configurar usuario root
    setup_user "/root" "root" "true"

    finish_banner
    success "Setup completo para ambos usuarios."
    success "Ahora 'sudo su' tendrá la misma configuración de zsh + powerlevel10k"
    warn "Reinicia tu terminal para aplicar los cambios completamente."
}

main
