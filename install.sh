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

# 🔧 Variables de configuración
DRY_RUN=${DRY_RUN:-0}
ENABLE_AUR=${ENABLE_AUR:-1}
VERIFY_INTEGRITY=${VERIFY_INTEGRITY:-1}
SKIP_BACKUP=${SKIP_BACKUP:-0}
SETUP_ROOT=${SETUP_ROOT:-0}

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

# 🔍 Verificar integridad de archivos
verify_integrity() {
    if [[ "$VERIFY_INTEGRITY" -eq 0 ]]; then
        warn "Verificación de integridad deshabilitada."
        return 0
    fi
    
    log "Verificando integridad de archivos..."
    
    local critical_files=(
        "zshrc.template"
        "p10k.zsh.template"
        "fastfetch/config.jsonc"
        "kitty/kitty.conf"
        "kitty/colors-dreamcoder.conf"
        "nano_custom/nanorc.conf"
    )
    
    for file in "${critical_files[@]}"; do
        if [[ ! -f "$CONFIG_DIR/$file" ]]; then
            error "Archivo crítico faltante: $file"
            return 1
        fi
    done
    
    success "Integridad de archivos verificada."
}

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
    
    # Verificar espacio en disco
    local available_space=$(df / | awk 'NR==2 {print $4}')
    if [ "$available_space" -lt 1048576 ]; then  # Menos de 1GB
        warn "Poco espacio en disco disponible: $(($available_space / 1024))MB"
        read -p "¿Continuar? (y/N): " -n 1 -r
        echo
        [[ ! $REPLY =~ ^[Yy]$ ]] && exit 1
    fi
    
    # Verificar conexión a internet
    if ! ping -c 1 archlinux.org &>/dev/null; then
        error "Sin conexión a internet. Verifica tu conexión."
        exit 1
    fi
    
    # Verificar AUR helpers
    if [[ "$ENABLE_AUR" -eq 1 ]]; then
        if command -v yay &>/dev/null; then
            log "AUR helper detectado: yay"
            AUR_HELPER="yay"
        elif command -v paru &>/dev/null; then
            log "AUR helper detectado: paru"
            AUR_HELPER="paru"
        else
            warn "No se detectó AUR helper (yay/paru). Solo se instalarán paquetes oficiales."
            ENABLE_AUR=0
        fi
    fi
    
    success "Sistema verificado correctamente."
}

# 📦 Actualizar sistema
update_system() {
    if [[ "$DRY_RUN" -eq 1 ]]; then
        log "[DRY RUN] Actualizando sistema..."
        return 0
    fi
    
    log "Actualizando sistema..."
    sudo pacman -Syu --noconfirm || {
        error "Fallo al actualizar el sistema."
        exit 1
    }
    success "Sistema actualizado."
}

# 📦 Instalar dependencias
install_dependencies() {
    log "Verificando e instalando dependencias necesarias..."
    
    # Paquetes principales (repositorios oficiales)
    local packages=(
        zsh fzf fd bat eza ripgrep jq zsh-autosuggestions
        zsh-syntax-highlighting zsh-completions thefuck
        duf dust btop xh lsof curl git neovim fastfetch
        ttf-meslo-nerd-font-powerlevel10k
    )
    
    # Paquetes AUR (opcionales)
    local aur_packages=(
        # Agregar paquetes AUR aquí si es necesario
        # Ejemplo: "paquete-aur"
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
        if [[ "$DRY_RUN" -eq 1 ]]; then
            log "[DRY RUN] Instalando paquetes: ${missing_packages[*]}"
        else
            log "Instalando paquetes faltantes: ${missing_packages[*]}"
            sudo pacman -S --noconfirm --needed "${missing_packages[@]}" || {
                error "Fallo al instalar paquetes."
                exit 1
            }
        fi
    fi
    
    # Instalar paquetes AUR si está habilitado
    if [[ "$ENABLE_AUR" -eq 1 ]] && [ ${#aur_packages[@]} -gt 0 ]; then
        local missing_aur_packages=()
        for pkg in "${aur_packages[@]}"; do
            if ! pacman -Q "$pkg" &>/dev/null; then
                missing_aur_packages+=("$pkg")
            else
                success "$pkg (AUR) ya está instalado."
            fi
        done
        
        if [ ${#missing_aur_packages[@]} -gt 0 ]; then
            if [[ "$DRY_RUN" -eq 1 ]]; then
                log "[DRY RUN] Instalando paquetes AUR: ${missing_aur_packages[*]}"
            else
                log "Instalando paquetes AUR: ${missing_aur_packages[*]}"
                "$AUR_HELPER" -S --noconfirm --needed "${missing_aur_packages[@]}" || {
                    warn "Fallo al instalar algunos paquetes AUR. Continuando..."
                }
            fi
        fi
    fi
    
    success "Todas las dependencias están instaladas."
}

# 🔤 Verificar fuentes Nerd Font
verify_nerd_fonts() {
    log "Verificando fuentes Nerd Font..."
    
    local font_paths=(
        "/usr/share/fonts/TTF/MesloLGS NF Regular.ttf"
        "/usr/share/fonts/nerd-fonts-meslo/MesloLGS NF Regular.ttf"
        "$HOME/.local/share/fonts/MesloLGS NF Regular.ttf"
    )
    
    local font_found=false
    for font_path in "${font_paths[@]}"; do
        if [[ -f "$font_path" ]]; then
            success "Fuente Nerd Font encontrada: $font_path"
            font_found=true
            break
        fi
    done
    
    if [[ "$font_found" == false ]]; then
        warn "No se encontraron fuentes Nerd Font. Algunos iconos pueden no mostrarse correctamente."
        if [[ "$DRY_RUN" -eq 0 ]]; then
            read -p "¿Instalar fuentes Nerd Font? (Y/n): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Nn]$ ]]; then
                warn "Saltando instalación de fuentes."
            else
                log "Instalando fuentes Nerd Font..."
                sudo pacman -S --noconfirm ttf-meslo-nerd-font-powerlevel10k || {
                    warn "Fallo al instalar fuentes. Continuando..."
                }
            fi
        fi
    fi
}

# 🗂️ Backup mejorado
backup_configs() {
    if [[ "$SKIP_BACKUP" -eq 1 ]]; then
        warn "Backup saltado por configuración."
        return 0
    fi
    
    local BACKUP_DIR="$HOME/.config_backup_$(date +%Y%m%d_%H%M%S)"
    log "Respaldando configuraciones en: $BACKUP_DIR"
    
    if [[ "$DRY_RUN" -eq 1 ]]; then
        log "[DRY RUN] Creando backup en: $BACKUP_DIR"
        return 0
    fi
    
    mkdir -p "$BACKUP_DIR"
    
    local configs=(
        ".zshrc"
        ".p10k.zsh"
        ".config/fastfetch"
        ".config/kitty"
        ".nanorc"
    )
    
    for config in "${configs[@]}"; do
        if [ -e "$HOME/$config" ]; then
            if [ -L "$HOME/$config" ]; then
                # Si es un symlink, eliminar y no hacer backup
                rm "$HOME/$config"
                log "Eliminado symlink existente: $config"
            else
                # Si es un archivo real, hacer backup
                cp -r "$HOME/$config" "$BACKUP_DIR/"
                success "Respaldo de $config realizado."
            fi
        fi
    done
    
    if [ -d "$BACKUP_DIR" ] && [ "$(ls -A "$BACKUP_DIR")" ]; then
        success "Backup completado en: $BACKUP_DIR"
    else
        log "No se encontraron configuraciones para respaldar."
        rmdir "$BACKUP_DIR" 2>/dev/null || true
    fi
}

# ⚡ Oh My Zsh + Powerlevel10k
setup_ohmyzsh_p10k() {
    # Instalar Oh My Zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        if [[ "$DRY_RUN" -eq 1 ]]; then
            log "[DRY RUN] Instalando Oh My Zsh..."
        else
            log "Instalando Oh My Zsh..."
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || {
                error "Fallo en la instalación de Oh My Zsh."
                exit 1
            }
        fi
    else
        success "Oh My Zsh ya está instalado."
    fi

    # Instalar Powerlevel10k
    local theme_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    if [ ! -d "$theme_dir" ]; then
        if [[ "$DRY_RUN" -eq 1 ]]; then
            log "[DRY RUN] Instalando Powerlevel10k..."
        else
            log "Instalando Powerlevel10k..."
            git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$theme_dir" || {
                error "Fallo al clonar Powerlevel10k."
                exit 1
            }
        fi
    else
        success "Powerlevel10k ya está instalado."
    fi
}

# 🔗 Symlinks mejorados
link_configs() {
    log "Creando enlaces simbólicos..."
    
    if [[ "$DRY_RUN" -eq 1 ]]; then
        log "[DRY RUN] Creando symlinks..."
        return 0
    fi
    
    # Crear directorios necesarios
    mkdir -p "$HOME/.config" "$HOME/.nano/backups"
    
    # Función para crear symlink seguro
    create_symlink() {
        local source="$1"
        local target="$2"
        local description="$3"
        
        if [ -e "$target" ] && [ ! -L "$target" ]; then
            warn "$description ya existe y no es un symlink. Saltando..."
            return 1
        fi
        
        ln -sf "$source" "$target" && success "$description enlazado." || {
            warn "Fallo al enlazar $description"
            return 1
        }
    }
    
    # Zsh & Powerlevel10k
    create_symlink "$CONFIG_DIR/zshrc.template" "$HOME/.zshrc" ".zshrc"
    create_symlink "$CONFIG_DIR/p10k.zsh.template" "$HOME/.p10k.zsh" ".p10k.zsh"
    
    # Bash fallback
    create_symlink "$CONFIG_DIR/bashrc.template" "$HOME/.bashrc" ".bashrc"
    
    # Fastfetch & Kitty
    create_symlink "$CONFIG_DIR/fastfetch" "$HOME/.config/fastfetch" "fastfetch"
    create_symlink "$CONFIG_DIR/kitty" "$HOME/.config/kitty" "kitty"
    
    # Nano
    create_symlink "$CONFIG_DIR/nano_custom/nanorc.conf" "$HOME/.nanorc" ".nanorc"
}

# 🧹 Limpieza
cleanup() {
    if [[ "$DRY_RUN" -eq 1 ]]; then
        log "[DRY RUN] Limpiando archivos temporales..."
        return 0
    fi
    
    log "Limpiando archivos temporales..."
    sudo pacman -Sc --noconfirm 2>/dev/null || true
    success "Limpieza completada."
}

# 🔧 Configurar entorno de root
setup_root_environment() {
    if [[ "$SETUP_ROOT" -eq 0 ]]; then
        return 0
    fi
    
    log "Configurando entorno de root..."
    
    if [[ "$DRY_RUN" -eq 1 ]]; then
        log "[DRY RUN] Configurando entorno de root..."
        return 0
    fi
    
    # Verificar permisos de root (solo si no se ejecuta automáticamente)
    if [[ $EUID -ne 0 ]] && [[ "$SETUP_ROOT" -eq 1 ]]; then
        warn "Configuración de root requiere permisos sudo"
        return 1
    fi
    
    # Instalar Oh My Zsh para root si no existe
    if [ ! -d "/root/.oh-my-zsh" ]; then
        log "Instalando Oh My Zsh para root..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || {
            error "Fallo en la instalación de Oh My Zsh para root."
            return 1
        }
    else
        success "Oh My Zsh ya está instalado para root."
    fi

    # Instalar Powerlevel10k para root
    local theme_dir="/root/.oh-my-zsh/custom/themes/powerlevel10k"
    if [ ! -d "$theme_dir" ]; then
        log "Instalando Powerlevel10k para root..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$theme_dir" || {
            error "Fallo al clonar Powerlevel10k para root."
            return 1
        }
    else
        success "Powerlevel10k ya está instalado para root."
    fi
    
    # Crear directorios necesarios
    mkdir -p "/root/.config" "/root/.nano/backups" "/root/.zsh"
    
    # Función para crear symlink seguro
    create_root_symlink() {
        local source="$1"
        local target="$2"
        local description="$3"
        
        if [ -e "$target" ] && [ ! -L "$target" ]; then
            warn "$description ya existe y no es un symlink. Haciendo backup..."
            mv "$target" "$target.backup.$(date +%Y%m%d_%H%M%S)"
        fi
        
        ln -sf "$source" "$target" && success "$description enlazado para root." || {
            warn "Fallo al enlazar $description para root"
            return 1
        }
    }
    
    # Zsh & Powerlevel10k
    create_root_symlink "$CONFIG_DIR/zshrc.template" "/root/.zshrc" ".zshrc"
    create_root_symlink "$CONFIG_DIR/p10k.zsh.template" "/root/.p10k.zsh" ".p10k.zsh"
    
    # Bash fallback
    create_root_symlink "$CONFIG_DIR/bashrc.template" "/root/.bashrc" ".bashrc"
    
    # Fastfetch & Kitty
    create_root_symlink "$CONFIG_DIR/fastfetch" "/root/.config/fastfetch" "fastfetch"
    create_root_symlink "$CONFIG_DIR/kitty" "/root/.config/kitty" "kitty"
    
    # Nano
    create_root_symlink "$CONFIG_DIR/nano_custom/nanorc.conf" "/root/.nanorc" ".nanorc"
    
    # Configurar permisos
    chown -R root:root /root/.config /root/.zsh /root/.oh-my-zsh 2>/dev/null || true
    chmod 700 /root/.config /root/.zsh /root/.oh-my-zsh 2>/dev/null || true
    
    success "Configuración de root completada."
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

# 📋 Mostrar información post-instalación
show_post_install_info() {
    echo -e "\n${BOLD}${CYAN}📋 Información Post-Instalación:${RESET}"
    echo -e "${YELLOW}•${RESET} Reinicia tu terminal para aplicar los cambios"
    echo -e "${YELLOW}•${RESET} Ejecuta 'p10k configure' para personalizar Powerlevel10k"
    echo -e "${YELLOW}•${RESET} Logs disponibles en: $LOGFILE"
    echo -e "${YELLOW}•${RESET} Configuraciones respaldadas en: $HOME/.config_backup_*"
    echo -e "${YELLOW}•${RESET} Para desinstalar: elimina los symlinks y ejecuta 'rm -rf ~/.oh-my-zsh'"
    
    if [[ "$ENABLE_AUR" -eq 1 ]]; then
        echo -e "${YELLOW}•${RESET} Soporte AUR habilitado con: $AUR_HELPER"
    fi
    
    if [[ "$SETUP_ROOT" -eq 1 ]]; then
        if [[ $EUID -eq 0 ]]; then
            echo -e "${YELLOW}•${RESET} Configuración de root completada. Usa 'sudo su' para probar"
            echo -e "${YELLOW}•${RESET} El entorno de root ahora tiene la misma configuración que tu usuario"
        else
            echo -e "${YELLOW}•${RESET} Configuración de root completada. Usa 'sudo su' para probar"
        fi
    fi
    
    if [[ "$DRY_RUN" -eq 1 ]]; then
        echo -e "${YELLOW}•${RESET} Modo DRY RUN: No se realizaron cambios reales"
    fi
}

# 🆘 Mostrar ayuda
show_help() {
    cat << EOF
🚀 Arch Dream Machine - Script de Instalación

Uso: $0 [OPCIONES]

Opciones:
  -h, --help           Mostrar esta ayuda
  --dry-run           Ejecutar en modo simulación (no hacer cambios)
  --no-aur            Deshabilitar soporte AUR
  --no-verify         Deshabilitar verificación de integridad
  --skip-backup       Saltar backup de configuraciones existentes
  --no-clear          No limpiar pantalla al inicio
  --setup-root        Configurar entorno de root (misma configuración)
                      (Se activa automáticamente si se ejecuta con sudo)

Variables de entorno:
  DRY_RUN=1           Modo simulación
  ENABLE_AUR=0        Deshabilitar AUR
  VERIFY_INTEGRITY=0  Deshabilitar verificación
  SKIP_BACKUP=1       Saltar backup

Ejemplos:
  $0                    # Instalación normal
  $0 --dry-run         # Simular instalación
  $0 --no-aur          # Solo paquetes oficiales
  $0 --setup-root      # Instalar + configurar root
  sudo $0              # Instalación normal + configuración automática de root
  DRY_RUN=1 $0         # Modo simulación con variable

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
            --no-aur)
                ENABLE_AUR=0
                shift
                ;;
            --no-verify)
                VERIFY_INTEGRITY=0
                shift
                ;;
            --skip-backup)
                SKIP_BACKUP=1
                shift
                ;;
            --no-clear)
                NO_CLEAR=1
                shift
                ;;
            --setup-root)
                SETUP_ROOT=1
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

# 🏁 Main mejorado
main() {
    process_args "$@"
    
    # Detectar si se ejecuta como root y habilitar configuración automática
    if [[ $EUID -eq 0 ]] && [[ "$SETUP_ROOT" -eq 0 ]]; then
        log "Detectado ejecución como root. Habilitando configuración automática de root..."
        SETUP_ROOT=1
        echo -e "${CYAN}🔧 Modo automático: Configurando entorno de root${RESET}"
    fi
    
    print_banner
    
    # Mostrar configuración actual
    echo -e "${YELLOW}⚙️  Configuración:${RESET}"
    echo -e "   • Modo DRY RUN: $([ "$DRY_RUN" -eq 1 ] && echo "SÍ" || echo "NO")"
    echo -e "   • Soporte AUR: $([ "$ENABLE_AUR" -eq 1 ] && echo "SÍ" || echo "NO")"
    echo -e "   • Verificación de integridad: $([ "$VERIFY_INTEGRITY" -eq 1 ] && echo "SÍ" || echo "NO")"
    echo -e "   • Backup: $([ "$SKIP_BACKUP" -eq 1 ] && echo "SALTADO" || echo "HABILITADO")"
    echo -e "   • Configuración de root: $([ "$SETUP_ROOT" -eq 1 ] && echo "SÍ" || echo "NO")"
    echo
    
    # Confirmación del usuario (solo si no es dry-run)
    if [[ "$DRY_RUN" -eq 0 ]]; then
        echo -e "${YELLOW}⚠️  Este script instalará y configurará:${RESET}"
        echo -e "   • Oh My Zsh + Powerlevel10k"
        echo -e "   • Fastfetch con temas personalizados"
        echo -e "   • Kitty terminal"
        echo -e "   • Configuración de Nano"
        echo -e "   • Herramientas adicionales (fzf, bat, eza, etc.)"
        if [[ "$SETUP_ROOT" -eq 1 ]]; then
            if [[ $EUID -eq 0 ]]; then
                echo -e "   • Configuración de root (ejecutando como root)"
            else
                echo -e "   • Configuración de root (misma configuración)"
            fi
        fi
        echo
        read -p "¿Continuar con la instalación? (y/N): " -n 1 -r
        echo
        [[ ! $REPLY =~ ^[Yy]$ ]] && {
            log "Instalación cancelada por el usuario."
            exit 0
        }
    fi
    
    # Ejecutar pasos de instalación
    verify_integrity
    check_system
    update_system
    
    (install_dependencies && verify_nerd_fonts && backup_configs && setup_ohmyzsh_p10k && link_configs && cleanup) &
    spinner $! "Aplicando tu configuración personalizada de Arch Dream Machine..."
    
    # Configurar entorno de root si se solicita
    if [[ "$SETUP_ROOT" -eq 1 ]]; then
        setup_root_environment
    fi

    finish_banner
    show_post_install_info
    
    # Mensaje específico según el modo de ejecución
    if [[ $EUID -eq 0 ]]; then
        success "Setup completo para root. ¡Disfruta tu nueva configuración!"
        echo -e "${CYAN}💡 Ahora puedes usar 'sudo su' para acceder a root con la misma configuración${RESET}"
    else
        success "Setup completo. ¡Disfruta tu nueva configuración!"
    fi
}

# Manejo de señales
trap 'echo -e "\n${RED}Instalación interrumpida.${RESET}"; exit 1' INT TERM

main "$@"
