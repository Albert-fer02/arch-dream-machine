#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

# 📁 Directorio base de configuración
CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 🎨 Colores
GREEN='\033[38;5;118m'
CYAN='\033[38;5;87m'
YELLOW='\033[38;5;226m'
RED='\033[38;5;196m'
BOLD='\033[1m'
RESET='\033[0m'

# 📢 Logs
log() { echo -e "${CYAN}[INFO]${RESET} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${RESET} $1"; }
warn() { echo -e "${YELLOW}[WARN]${RESET} $1"; }
error() { echo -e "${RED}[ERROR]${RESET} $1"; }

# 🔍 Verificar permisos
check_permissions() {
    if [[ $EUID -ne 0 ]]; then
        error "Este script debe ejecutarse como root. Usa: sudo $0"
        exit 1
    fi
}

# 🎯 Banner
print_banner() {
    echo -e "${BOLD}${CYAN}🔧 Configuración de Root - Arch Dream Machine${RESET}"
    echo "=================================================="
    echo
}

# ⚡ Configurar Oh My Zsh para root
setup_root_ohmyzsh() {
    log "Configurando Oh My Zsh para root..."
    
    # Verificar si Oh My Zsh ya está instalado para root
    if [[ ! -d "/root/.oh-my-zsh" ]]; then
        log "Instalando Oh My Zsh para root..."
        export HOME="/root"
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || {
            error "Fallo en la instalación de Oh My Zsh para root."
            exit 1
        }
        success "Oh My Zsh instalado para root."
    else
        success "Oh My Zsh ya está instalado para root."
    fi
    
    # Instalar Powerlevel10k para root
    local theme_dir="/root/.oh-my-zsh/custom/themes/powerlevel10k"
    if [[ ! -d "$theme_dir" ]]; then
        log "Instalando Powerlevel10k para root..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$theme_dir" || {
            error "Fallo al clonar Powerlevel10k para root."
            exit 1
        }
        success "Powerlevel10k instalado para root."
    else
        success "Powerlevel10k ya está instalado para root."
    fi
}

# 🔗 Crear enlaces simbólicos para root
setup_root_symlinks() {
    log "Creando enlaces simbólicos para root..."
    
    # Zsh & Powerlevel10k
    ln -sf "$CONFIG_DIR/zshrc.template" "/root/.zshrc" && success "✓ Root .zshrc enlazado" || warn "⚠ Fallo al enlazar .zshrc"
    ln -sf "$CONFIG_DIR/p10k.zsh.template" "/root/.p10k.zsh" && success "✓ Root .p10k.zsh enlazado" || warn "⚠ Fallo al enlazar .p10k.zsh"
    
    # Configuraciones adicionales
    mkdir -p "/root/.config"
    if [[ -d "$CONFIG_DIR/fastfetch" ]]; then
        ln -sfn "$CONFIG_DIR/fastfetch" "/root/.config/fastfetch" && success "✓ Root fastfetch enlazado" || warn "⚠ Fallo al enlazar fastfetch"
    fi
    
    if [[ -d "$CONFIG_DIR/kitty" ]]; then
        ln -sfn "$CONFIG_DIR/kitty" "/root/.config/kitty" && success "✓ Root kitty enlazado" || warn "⚠ Fallo al enlazar kitty"
    fi
    
    # Nano
    if [[ -f "$CONFIG_DIR/nano_custom/nanorc.conf" ]]; then
        ln -sf "$CONFIG_DIR/nano_custom/nanorc.conf" "/root/.nanorc" && success "✓ Root .nanorc enlazado" || warn "⚠ Fallo al enlazar .nanorc"
    fi
}

# 🐚 Cambiar shell de root a Zsh
setup_root_shell() {
    log "Configurando shell de root..."
    
    if command -v zsh &>/dev/null; then
        local current_shell=$(grep "^root:" /etc/passwd | cut -d: -f7)
        if [[ "$current_shell" != "/usr/bin/zsh" ]]; then
            log "Cambiando shell de root a Zsh..."
            chsh -s /usr/bin/zsh root && success "✓ Shell de root cambiado a Zsh" || {
                warn "⚠ No se pudo cambiar shell de root automáticamente"
                echo "Ejecuta manualmente: chsh -s /usr/bin/zsh root"
            }
        else
            success "✓ Root ya usa Zsh como shell"
        fi
    else
        error "Zsh no está instalado en el sistema"
        exit 1
    fi
}

# 📋 Mostrar información
show_info() {
    echo
    echo -e "${BOLD}${GREEN}🎉 Configuración de Root Completada${RESET}"
    echo "======================================="
    echo
    echo "Ahora cuando uses 'sudo su' tendrás:"
    echo "• Mismo prompt que tu usuario normal"
    echo "• Powerlevel10k configurado"
    echo "• Todas las funciones y aliases"
    echo "• Configuración de colores y tema"
    echo
    echo "Para probar:"
    echo -e "${CYAN}sudo su${RESET}"
    echo
    echo "El prompt debería verse igual que tu usuario normal."
}

# 🏁 Main
main() {
    print_banner
    check_permissions
    setup_root_ohmyzsh
    setup_root_symlinks
    setup_root_shell
    show_info
}

main "$@"
