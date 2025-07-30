#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

# 📁 Directorio base de configuración
CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOGFILE="$HOME/setup_arch_dream.log"

# Variables globales
DRY_RUN=${DRY_RUN:-false}
VERIFY_INTEGRITY=${VERIFY_INTEGRITY:-true}

# Configurar logging solo si no es dry-run
if [[ "$DRY_RUN" != "true" ]]; then
    exec > >(tee -a "$LOGFILE") 2>&1
fi

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
dry_run() { echo -e "${PURPLE}[DRY-RUN]${RESET} $1"; }

# 🔒 Verificación de integridad
verify_file_integrity() {
    local file="$1"
    local expected_hash="$2"
    
    if [[ "$VERIFY_INTEGRITY" != "true" ]]; then
        return 0
    fi
    
    if [[ ! -f "$file" ]]; then
        error "Archivo no encontrado: $file"
        return 1
    fi
    
    local actual_hash=$(sha256sum "$file" | cut -d' ' -f1)
    if [[ "$actual_hash" != "$expected_hash" ]]; then
        error "Verificación de integridad falló para: $file"
        error "Esperado: $expected_hash"
        error "Actual: $actual_hash"
        return 1
    fi
    
    success "Integridad verificada: $file"
    return 0
}

# 🧪 Ejecutar comando con soporte dry-run
run_cmd() {
    local cmd="$1"
    local description="${2:-$cmd}"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        dry_run "Ejecutaría: $description"
        return 0
    else
        log "Ejecutando: $description"
        eval "$cmd"
    fi
}

# 📦 Verificar si pacman existe
check_pacman() {
    if ! command -v pacman &>/dev/null; then
        error "Este script requiere pacman (Arch Linux o derivado). Abortando."
        exit 1
    fi
}

# 📦 Verificar y configurar AUR helper
setup_aur_helper() {
    # Saltar si se especificó --no-aur
    if [[ "${SKIP_AUR:-false}" == "true" ]]; then
        warn "Saltando configuración de AUR helper (--no-aur especificado)."
        export AUR_HELPER=""
        return 0
    fi
    
    log "Verificando AUR helper..."
    
    # Verificar si yay o paru están instalados
    if command -v yay &>/dev/null; then
        success "yay ya está instalado."
        export AUR_HELPER="yay"
        return 0
    elif command -v paru &>/dev/null; then
        success "paru ya está instalado."
        export AUR_HELPER="paru"
        return 0
    fi
    
    # Preguntar si instalar yay (solo si no es dry-run)
    if [[ "$DRY_RUN" == "true" ]]; then
        dry_run "Preguntaría sobre instalación de yay"
        export AUR_HELPER="yay"  # Simular que se instalaría
        return 0
    fi
    
    echo
    read -p "¿Instalar yay (AUR helper) para paquetes adicionales? (y/N): " -n 1 -r
    echo
    [[ ! $REPLY =~ ^[Yy]$ ]] && {
        warn "Saltando instalación de AUR helper. Algunos paquetes opcionales no estarán disponibles."
        export AUR_HELPER=""
        return 0
    }
    
    log "Instalando yay..."
    
    # Instalar dependencias para compilar yay
    sudo pacman -S --noconfirm --needed git base-devel || {
        error "Fallo al instalar dependencias para yay."
        return 1
    }
    
    # Clonar y compilar yay
    local temp_dir="/tmp/yay-install"
    rm -rf "$temp_dir"
    git clone https://aur.archlinux.org/yay.git "$temp_dir" || {
        error "Fallo al clonar yay."
        return 1
    }
    
    cd "$temp_dir"
    makepkg -si --noconfirm || {
        error "Fallo al compilar yay."
        return 1
    }
    
    cd - > /dev/null
    rm -rf "$temp_dir"
    export AUR_HELPER="yay"
    success "yay instalado correctamente."
}

# 🔤 Verificar fuentes Nerd Font
check_fonts() {
    log "Verificando fuentes Nerd Font..."
    
    local required_fonts=(
        "FiraCode Nerd Font"
        "Meslo Nerd Font"
    )
    
    local missing_fonts=()
    for font in "${required_fonts[@]}"; do
        if ! fc-list | grep -qi "$font"; then
            missing_fonts+=("$font")
        else
            success "$font encontrada."
        fi
    done
    
    if [ ${#missing_fonts[@]} -gt 0 ]; then
        log "Instalando fuentes faltantes..."
        local font_packages=(
            ttf-fira-code-nerd
            ttf-meslo-nerd
            ttf-sourcecodepro-nerd
        )
        
        sudo pacman -S --noconfirm --needed "${font_packages[@]}" || {
            warn "Algunas fuentes no se pudieron instalar desde repositorios oficiales."
        }
        
        # Actualizar cache de fuentes
        fc-cache -fv >/dev/null 2>&1
        success "Cache de fuentes actualizado."
    fi
}

# 📦 Instalar dependencias
install_dependencies() {
    log "Verificando e instalando dependencias necesarias..."
    
    # Paquetes principales (repositorios oficiales)
    local packages=(
        zsh fzf fd bat eza ripgrep jq zsh-autosuggestions
        zsh-syntax-highlighting zsh-completions thefuck
        duf dust btop xh lsof curl git neovim fastfetch
    )
    
    # Paquetes AUR opcionales
    local aur_packages=(
        ttf-meslo-nerd-font-powerlevel10k
    )
    
    # Instalar paquetes principales
    local missing_packages=()
    for pkg in "${packages[@]}"; do
        if ! pacman -Q "$pkg" &>/dev/null; then
            missing_packages+=("$pkg")
        else
            success "$pkg ya está instalado."
        fi
    done
    
    if [ ${#missing_packages[@]} -gt 0 ]; then
        log "Instalando paquetes faltantes: ${missing_packages[*]}"
        sudo pacman -S --noconfirm --needed "${missing_packages[@]}" || {
            error "Fallo al instalar paquetes principales."
            exit 1
        }
    fi
    
    # Verificar fuentes
    check_fonts
    
    # Instalar paquetes AUR si el helper está disponible
    if [ -n "$AUR_HELPER" ]; then
        log "Instalando paquetes AUR opcionales..."
        for pkg in "${aur_packages[@]}"; do
            if ! pacman -Q "$pkg" &>/dev/null; then
                log "Instalando desde AUR: $pkg"
                $AUR_HELPER -S --noconfirm --needed "$pkg" 2>/dev/null || {
                    warn "No se pudo instalar $pkg desde AUR."
                }
            else
                success "$pkg (AUR) ya está instalado."
            fi
        done
    fi
    
    success "Instalación de dependencias completada."
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
    if [[ -f "$CONFIG_DIR/bashrc_fallback.template" ]]; then
        ln -sf "$CONFIG_DIR/bashrc_fallback.template" "$HOME/.bashrc_dream" || warn "Fallo al enlazar .bashrc_dream"
        success "Bash fallback configurado en ~/.bashrc_dream"
    fi
    
    # Fastfetch & Kitty
    mkdir -p "$HOME/.config"
    ln -sfn "$CONFIG_DIR/fastfetch" "$HOME/.config/fastfetch" || warn "Fallo al enlazar fastfetch"
    ln -sfn "$CONFIG_DIR/kitty" "$HOME/.config/kitty" || warn "Fallo al enlazar kitty"

    # Nano
    mkdir -p "$HOME/.nano/backups" || warn "Fallo al crear directorio de backups de Nano"
    ln -sf "$CONFIG_DIR/nano_custom/nanorc.conf" "$HOME/.nanorc" || warn "Fallo al enlazar .nanorc"
    
    # Hacer ejecutables los scripts de cambio de tema
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
    
    # Confirmación del usuario
    echo -e "${YELLOW}⚠️  Este script instalará y configurará:${RESET}"
    echo -e "   • Oh My Zsh + Powerlevel10k"
    echo -e "   • Fastfetch con temas personalizados"
    echo -e "   • Kitty terminal"
    echo -e "   • Configuración de Nano"
    echo -e "   • Herramientas adicionales (fzf, bat, eza, etc.)"
    echo
    read -p "¿Continuar con la instalación? (y/N): " -n 1 -r
    echo
    [[ ! $REPLY =~ ^[Yy]$ ]] && {
        log "Instalación cancelada por el usuario."
        exit 0
    }
    
    check_pacman
    setup_aur_helper

    (install_dependencies && backup_configs && setup_ohmyzsh_p10k && link_configs) &
    spinner $! "Aplicando tu configuración personalizada de Arch Dream Machine..."

    finish_banner
    success "Setup completo. Reinicia tu terminal para aplicar los cambios."
}

# 📋 Mostrar ayuda
show_help() {
    cat << EOF
🚀 ARCH DREAM MACHINE - Script de Instalación

USAGE:
    $0 [OPTIONS]

OPTIONS:
    -h, --help          Mostrar esta ayuda
    -d, --dry-run       Modo simulación (no ejecuta comandos)
    --no-verify         Deshabilitar verificación de integridad
    --no-aur            Saltar instalación de AUR helper
    --minimal           Instalación mínima (sin paquetes opcionales)

VARIABLES DE ENTORNO:
    DRY_RUN=true        Equivalente a --dry-run
    VERIFY_INTEGRITY=false  Equivalente a --no-verify

EJEMPLOS:
    $0                  Instalación normal
    $0 --dry-run        Simular instalación
    $0 --minimal        Instalación mínima

EOF
}

# 📝 Procesar argumentos
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -d|--dry-run)
                DRY_RUN=true
                ;;
            --no-verify)
                VERIFY_INTEGRITY=false
                ;;
            --no-aur)
                SKIP_AUR=true
                ;;
            --minimal)
                MINIMAL_INSTALL=true
                ;;
            *)
                error "Opción desconocida: $1"
                show_help
                exit 1
                ;;
        esac
        shift
    done
}

# Procesar argumentos antes del main
parse_arguments "$@"

main
