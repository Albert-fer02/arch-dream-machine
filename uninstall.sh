#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

# 📁 Directorio base de configuración
CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOGFILE="$HOME/uninstall_arch_dream.log"
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

# 🔧 Variables de configuración
DRY_RUN=${DRY_RUN:-0}
REMOVE_PACKAGES=${REMOVE_PACKAGES:-0}
REMOVE_OHMYZSH=${REMOVE_OHMYZSH:-0}
RESTORE_BACKUP=${RESTORE_BACKUP:-1}
REMOVE_ROOT=${REMOVE_ROOT:-0}

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
║                        🗑️  ARCH DREAM MACHINE UNINSTALL 🗑️                    ║
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

# 🔍 Verificar sistema
check_system() {
    log "Verificando sistema..."
    
    # Verificar si es Arch Linux o derivado
    if ! command -v pacman &>/dev/null; then
        error "Este script requiere pacman (Arch Linux o derivado). Abortando."
        exit 1
    fi
    
    # Verificar si el usuario tiene permisos sudo
    if ! sudo -n true 2>/dev/null; then
        error "Se requieren permisos sudo. Ejecuta: sudo -v"
        exit 1
    fi
    
    success "Sistema verificado correctamente."
}

# 🔗 Remover symlinks
remove_symlinks() {
    log "Removiendo enlaces simbólicos..."
    
    if [[ "$DRY_RUN" -eq 1 ]]; then
        log "[DRY RUN] Removiendo symlinks..."
        return 0
    fi
    
    local symlinks=(
        "$HOME/.zshrc"
        "$HOME/.p10k.zsh"
        "$HOME/.bashrc"
        "$HOME/.config/fastfetch"
        "$HOME/.config/kitty"
        "$HOME/.nanorc"
    )
    
    for symlink in "${symlinks[@]}"; do
        if [ -L "$symlink" ]; then
            rm "$symlink" && success "Removido symlink: $symlink" || warn "Error removiendo: $symlink"
        elif [ -e "$symlink" ]; then
            warn "Archivo real encontrado (no symlink): $symlink"
        fi
    done
}

# 🔄 Restaurar backup
restore_backup() {
    if [[ "$RESTORE_BACKUP" -eq 0 ]]; then
        warn "Restauración de backup deshabilitada."
        return 0
    fi
    
    log "Buscando backups para restaurar..."
    
    # Buscar el backup más reciente
    local backup_dirs=($(find "$HOME" -maxdepth 1 -name ".config_backup_*" -type d 2>/dev/null | sort -r))
    
    if [ ${#backup_dirs[@]} -eq 0 ]; then
        warn "No se encontraron backups para restaurar."
        return 0
    fi
    
    local latest_backup="${backup_dirs[0]}"
    log "Backup encontrado: $latest_backup"
    
    if [[ "$DRY_RUN" -eq 1 ]]; then
        log "[DRY RUN] Restaurando desde: $latest_backup"
        return 0
    fi
    
    read -p "¿Restaurar configuración desde $latest_backup? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        log "Restaurando configuración..."
        cp -r "$latest_backup"/* "$HOME/" 2>/dev/null || warn "Error restaurando algunos archivos"
        success "Configuración restaurada desde backup."
    else
        warn "Restauración cancelada por el usuario."
    fi
}

# 📦 Remover paquetes (opcional)
remove_packages() {
    if [[ "$REMOVE_PACKAGES" -eq 0 ]]; then
        log "Remoción de paquetes deshabilitada."
        return 0
    fi
    
    log "Removiendo paquetes instalados..."
    
    # Paquetes a remover
    local packages=(
        zsh-autosuggestions
        zsh-syntax-highlighting
        zsh-completions
        thefuck
        duf
        dust
        btop
        xh
        fastfetch
        ttf-meslo-nerd-font-powerlevel10k
    )
    
    if [[ "$DRY_RUN" -eq 1 ]]; then
        log "[DRY RUN] Removiendo paquetes: ${packages[*]}"
        return 0
    fi
    
    local installed_packages=()
    for pkg in "${packages[@]}"; do
        if pacman -Q "$pkg" &>/dev/null; then
            installed_packages+=("$pkg")
        fi
    done
    
    if [ ${#installed_packages[@]} -gt 0 ]; then
        read -p "¿Remover paquetes: ${installed_packages[*]}? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            sudo pacman -R --noconfirm "${installed_packages[@]}" || warn "Error removiendo algunos paquetes"
            success "Paquetes removidos."
        else
            warn "Remoción de paquetes cancelada."
        fi
    else
        log "No se encontraron paquetes para remover."
    fi
}

# 🗑️ Remover Oh My Zsh (opcional)
remove_ohmyzsh() {
    if [[ "$REMOVE_OHMYZSH" -eq 0 ]]; then
        log "Remoción de Oh My Zsh deshabilitada."
        return 0
    fi
    
    if [ -d "$HOME/.oh-my-zsh" ]; then
        if [[ "$DRY_RUN" -eq 1 ]]; then
            log "[DRY RUN] Removiendo Oh My Zsh..."
            return 0
        fi
        
        read -p "¿Remover Oh My Zsh completamente? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf "$HOME/.oh-my-zsh" && success "Oh My Zsh removido." || error "Error removiendo Oh My Zsh"
        else
            warn "Remoción de Oh My Zsh cancelada."
        fi
    else
        log "Oh My Zsh no encontrado."
    fi
}

# 🧹 Limpieza final
cleanup() {
    log "Limpiando archivos temporales..."
    
    if [[ "$DRY_RUN" -eq 1 ]]; then
        log "[DRY RUN] Limpiando archivos temporales..."
        return 0
    fi
    
    # Remover logs de instalación
    rm -f "$HOME/setup_arch_dream.log"
    
    # Limpiar cache de Zsh
    rm -rf "$HOME/.zsh/cache" 2>/dev/null || true
    
    # Remover directorios vacíos
    rmdir "$HOME/.config/fastfetch" 2>/dev/null || true
    rmdir "$HOME/.config/kitty" 2>/dev/null || true
    
    success "Limpieza completada."
}

# 🔧 Remover configuración de root
remove_root_config() {
    if [[ "$REMOVE_ROOT" -eq 0 ]]; then
        return 0
    fi
    
    log "Removiendo configuración de root..."
    
    if [[ "$DRY_RUN" -eq 1 ]]; then
        log "[DRY RUN] Removiendo configuración de root..."
        return 0
    fi
    
    # Verificar permisos de root
    if [[ $EUID -ne 0 ]]; then
        warn "Remoción de configuración de root requiere permisos sudo"
        return 1
    fi
    
    # Remover symlinks de root
    local symlinks=(
        "/root/.zshrc"
        "/root/.p10k.zsh"
        "/root/.bashrc"
        "/root/.nanorc"
        "/root/.config/fastfetch"
        "/root/.config/kitty"
    )
    
    for symlink in "${symlinks[@]}"; do
        if [ -L "$symlink" ]; then
            rm "$symlink" && log "Eliminado: $symlink"
        elif [ -e "$symlink" ]; then
            warn "Archivo real encontrado (no symlink): $symlink"
            read -p "¿Eliminar archivo real? (y/N): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                rm -rf "$symlink" && log "Eliminado: $symlink"
            else
                log "Saltando: $symlink"
            fi
        fi
    done
    
    # Remover Oh My Zsh de root si se solicita
    if [[ "$REMOVE_OHMYZSH" -eq 1 ]] && [ -d "/root/.oh-my-zsh" ]; then
        read -p "¿Eliminar Oh My Zsh de root? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf "/root/.oh-my-zsh" && success "Oh My Zsh eliminado de root"
        else
            log "Saltando eliminación de Oh My Zsh de root"
        fi
    fi
    
    # Limpiar directorios vacíos
    local dirs=(
        "/root/.config/fastfetch"
        "/root/.config/kitty"
        "/root/.config"
        "/root/.zsh"
    )
    
    for dir in "${dirs[@]}"; do
        if [ -d "$dir" ] && [ -z "$(ls -A "$dir")" ]; then
            rmdir "$dir" && log "Directorio vacío eliminado: $dir"
        fi
    done
    
    # Restaurar configuración por defecto
    cat > "/root/.zshrc" << 'EOF'
# Configuración básica de Zsh para root
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export HISTSIZE=1000
export SAVEHIST=1000
export HISTFILE=~/.zsh_history
setopt SHARE_HISTORY

# Prompt básico
PS1='%F{red}%n@%m%f:%F{blue}%~%f# '

# Comandos básicos
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Completions
autoload -Uz compinit
compinit
EOF

    success "Configuración de root removida y restaurada por defecto."
}

# 🎊 Final
finish_banner() {
    local COLOR='\033[1;37m'  # Blanco brillante
    local RESET='\033[0m'

    echo -e "${COLOR}"
    cat << EOF
╔════════════════════════════════════════════════════════════════════════════╗
║                        🎉 UNINSTALLATION COMPLETE 🎉                       ║
║                                                                            ║
║    Crafted with 💙 by: 𓂀 𝓓𝓻𝓮𝓪𝓶𝓬𝓸𝓭𝓮𝓻08 𓂀                                   ║
╚════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${RESET}"
}

# 📋 Mostrar información post-desinstalación
show_post_uninstall_info() {
    echo -e "\n${BOLD}${CYAN}📋 Información Post-Desinstalación:${RESET}"
    echo -e "${YELLOW}•${RESET} Reinicia tu terminal para aplicar los cambios"
    echo -e "${YELLOW}•${RESET} Logs disponibles en: $LOGFILE"
    
    if [[ "$RESTORE_BACKUP" -eq 1 ]]; then
        echo -e "${YELLOW}•${RESET} Configuración anterior restaurada desde backup"
    fi
    
    if [[ "$REMOVE_PACKAGES" -eq 1 ]]; then
        echo -e "${YELLOW}•${RESET} Paquetes removidos del sistema"
    fi
    
    if [[ "$REMOVE_OHMYZSH" -eq 1 ]]; then
        echo -e "${YELLOW}•${RESET} Oh My Zsh removido completamente"
    fi
    
    if [[ "$REMOVE_ROOT" -eq 1 ]]; then
        echo -e "${YELLOW}•${RESET} Configuración de root removida"
    fi
    
    if [[ "$DRY_RUN" -eq 1 ]]; then
        echo -e "${YELLOW}•${RESET} Modo DRY RUN: No se realizaron cambios reales"
    fi
    
    echo -e "${YELLOW}•${RESET} Para reinstalar: ejecuta ./install.sh"
}

# 🆘 Mostrar ayuda
show_help() {
    cat << EOF
🗑️  Arch Dream Machine - Script de Desinstalación

Uso: $0 [OPCIONES]

Opciones:
  -h, --help           Mostrar esta ayuda
  --dry-run           Ejecutar en modo simulación (no hacer cambios)
  --remove-packages   Remover paquetes instalados
  --remove-ohmyzsh    Remover Oh My Zsh completamente
  --remove-root       Remover configuración de root
  --no-restore        No restaurar configuración desde backup
  --no-clear          No limpiar pantalla al inicio

Variables de entorno:
  DRY_RUN=1           Modo simulación
  REMOVE_PACKAGES=1   Remover paquetes
  REMOVE_OHMYZSH=1    Remover Oh My Zsh
  RESTORE_BACKUP=0    No restaurar backup

Ejemplos:
  $0                    # Desinstalación básica (solo symlinks)
  $0 --dry-run         # Simular desinstalación
  $0 --remove-packages # Remover también paquetes
  $0 --remove-ohmyzsh  # Remover Oh My Zsh también
  $0 --remove-root     # Remover configuración de root
  DRY_RUN=1 $0         # Modo simulación con variable

⚠️  ADVERTENCIA: Este script puede remover configuraciones personalizadas.
    Se recomienda hacer backup antes de ejecutar.

EOF
}

# 🔧 Procesar argumentos
process_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            --dry-run)
                DRY_RUN=1
                shift
                ;;
            --remove-packages)
                REMOVE_PACKAGES=1
                shift
                ;;
            --remove-ohmyzsh)
                REMOVE_OHMYZSH=1
                shift
                ;;
            --no-restore)
                RESTORE_BACKUP=0
                shift
                ;;
            --no-clear)
                NO_CLEAR=1
                shift
                ;;
            --remove-root)
                REMOVE_ROOT=1
                shift
                ;;
            *)
                error "Opción desconocida: $1"
                show_help
                exit 1
                ;;
        esac
    done
}

# 🏁 Main
main() {
    process_args "$@"
    
    print_banner
    
    # Mostrar configuración actual
    echo -e "${YELLOW}⚙️  Configuración:${RESET}"
    echo -e "   • Modo DRY RUN: $([ "$DRY_RUN" -eq 1 ] && echo "SÍ" || echo "NO")"
    echo -e "   • Remover paquetes: $([ "$REMOVE_PACKAGES" -eq 1 ] && echo "SÍ" || echo "NO")"
    echo -e "   • Remover Oh My Zsh: $([ "$REMOVE_OHMYZSH" -eq 1 ] && echo "SÍ" || echo "NO")"
    echo -e "   • Restaurar backup: $([ "$RESTORE_BACKUP" -eq 1 ] && echo "SÍ" || echo "NO")"
    echo -e "   • Remover configuración de root: $([ "$REMOVE_ROOT" -eq 1 ] && echo "SÍ" || echo "NO")"
    echo
    
    # Confirmación del usuario (solo si no es dry-run)
    if [[ "$DRY_RUN" -eq 0 ]]; then
        echo -e "${YELLOW}⚠️  Este script desinstalará:${RESET}"
        echo -e "   • Enlaces simbólicos de configuración"
        if [[ "$RESTORE_BACKUP" -eq 1 ]]; then
            echo -e "   • Restaurará configuración anterior desde backup"
        fi
        if [[ "$REMOVE_PACKAGES" -eq 1 ]]; then
            echo -e "   • Removerá paquetes instalados"
        fi
        if [[ "$REMOVE_OHMYZSH" -eq 1 ]]; then
            echo -e "   • Removerá Oh My Zsh completamente"
        fi
        if [[ "$REMOVE_ROOT" -eq 1 ]]; then
            echo -e "   • Removerá configuración de root"
        fi
        echo
        read -p "¿Continuar con la desinstalación? (y/N): " -n 1 -r
        echo
        [[ ! $REPLY =~ ^[Yy]$ ]] && {
            log "Desinstalación cancelada por el usuario."
            exit 0
        }
    fi
    
    # Ejecutar pasos de desinstalación
    check_system
    
    (remove_symlinks && restore_backup && remove_packages && remove_ohmyzsh && cleanup) &
    spinner $! "Desinstalando Arch Dream Machine..."
    
    # Remover configuración de root si se solicita
    if [[ "$REMOVE_ROOT" -eq 1 ]]; then
        remove_root_config
    fi

    finish_banner
    show_post_uninstall_info
    success "Desinstalación completa."
}

# Manejo de señales
trap 'echo -e "\n${RED}Desinstalación interrumpida.${RESET}"; exit 1' INT TERM

main "$@" 