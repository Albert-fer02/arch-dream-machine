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

# 🔍 Verificar integridad de archivos
verify_files() {
    log "Verificando integridad de archivos..."
    
    local critical_files=(
        "install.sh"
        "uninstall.sh"
        "zshrc.template"
        "p10k.zsh.template"
        "bashrc.template"
        "fastfetch/config.jsonc"
        "kitty/kitty.conf"
        "kitty/colors-dreamcoder.conf"
        "nano_custom/nanorc.conf"
        "README.md"
    )
    
    local missing_files=()
    local total_files=${#critical_files[@]}
    local found_files=0
    
    for file in "${critical_files[@]}"; do
        if [[ -f "$CONFIG_DIR/$file" ]]; then
            success "✓ $file"
            ((found_files++))
        else
            error "✗ $file (FALTANTE)"
            missing_files+=("$file")
        fi
    done
    
    echo
    echo "📊 Resumen:"
    echo "   • Archivos encontrados: $found_files/$total_files"
    
    if [ ${#missing_files[@]} -gt 0 ]; then
        echo "   • Archivos faltantes: ${#missing_files[@]}"
        for file in "${missing_files[@]}"; do
            echo "     - $file"
        done
        return 1
    else
        success "Todos los archivos críticos están presentes."
        return 0
    fi
}

# 🔧 Verificar permisos de ejecución
verify_permissions() {
    log "Verificando permisos de ejecución..."
    
    local executable_files=(
        "install.sh"
        "uninstall.sh"
        "verify.sh"
    )
    
    local permission_issues=()
    
    for file in "${executable_files[@]}"; do
        if [[ -f "$CONFIG_DIR/$file" ]]; then
            if [[ -x "$CONFIG_DIR/$file" ]]; then
                success "✓ $file (ejecutable)"
            else
                warn "⚠ $file (no ejecutable)"
                permission_issues+=("$file")
            fi
        fi
    done
    
    if [ ${#permission_issues[@]} -gt 0 ]; then
        echo
        warn "Archivos que necesitan permisos de ejecución:"
        for file in "${permission_issues[@]}"; do
            echo "   chmod +x $file"
        done
        return 1
    fi
    
    return 0
}

# 📦 Verificar dependencias del sistema
verify_dependencies() {
    log "Verificando dependencias del sistema..."
    
    local dependencies=(
        "bash"
        "pacman"
        "curl"
        "git"
    )
    
    local missing_deps=()
    
    for dep in "${dependencies[@]}"; do
        if command -v "$dep" &>/dev/null; then
            success "✓ $dep"
        else
            error "✗ $dep (NO ENCONTRADO)"
            missing_deps+=("$dep")
        fi
    done
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        echo
        warn "Dependencias faltantes: ${missing_deps[*]}"
        return 1
    fi
    
    return 0
}

# 🔗 Verificar symlinks (si existen)
verify_symlinks() {
    log "Verificando symlinks de configuración..."
    
    local symlinks=(
        "$HOME/.zshrc"
        "$HOME/.p10k.zsh"
        "$HOME/.bashrc"
        "$HOME/.config/fastfetch"
        "$HOME/.config/kitty"
        "$HOME/.nanorc"
    )
    
    local symlink_count=0
    local total_symlinks=${#symlinks[@]}
    
    for symlink in "${symlinks[@]}"; do
        if [[ -L "$symlink" ]]; then
            local target=$(readlink "$symlink")
            if [[ "$target" == *"$CONFIG_DIR"* ]]; then
                success "✓ $symlink -> $target"
                ((symlink_count++))
            else
                warn "⚠ $symlink -> $target (no apunta a este proyecto)"
            fi
        elif [[ -e "$symlink" ]]; then
            warn "⚠ $symlink (archivo real, no symlink)"
        else
            log "○ $symlink (no existe)"
        fi
    done
    
    echo
    echo "📊 Symlinks configurados: $symlink_count/$total_symlinks"
    
    if [ $symlink_count -eq $total_symlinks ]; then
        success "Todos los symlinks están configurados correctamente."
        return 0
    else
        warn "Algunos symlinks no están configurados."
        return 1
    fi
}

# 🧪 Verificar configuración de Zsh
verify_zsh_config() {
    log "Verificando configuración de Zsh..."
    
    if ! command -v zsh &>/dev/null; then
        warn "Zsh no está instalado"
        return 1
    fi
    
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        success "✓ Oh My Zsh instalado"
    else
        warn "⚠ Oh My Zsh no instalado"
    fi
    
    if [[ -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]]; then
        success "✓ Powerlevel10k instalado"
    else
        warn "⚠ Powerlevel10k no instalado"
    fi
    
    if [[ -f "$HOME/.p10k.zsh" ]]; then
        success "✓ Configuración Powerlevel10k presente"
    else
        warn "⚠ Configuración Powerlevel10k faltante"
    fi
}

# 🎨 Verificar fuentes Nerd Font
verify_fonts() {
    log "Verificando fuentes Nerd Font..."
    
    local font_paths=(
        "/usr/share/fonts/TTF/MesloLGS NF Regular.ttf"
        "/usr/share/fonts/nerd-fonts-meslo/MesloLGS NF Regular.ttf"
        "$HOME/.local/share/fonts/MesloLGS NF Regular.ttf"
    )
    
    local font_found=false
    
    for font_path in "${font_paths[@]}"; do
        if [[ -f "$font_path" ]]; then
            success "✓ Fuente encontrada: $font_path"
            font_found=true
            break
        fi
    done
    
    if [[ "$font_found" == false ]]; then
        warn "⚠ No se encontraron fuentes Nerd Font"
        echo "   Instalar con: sudo pacman -S ttf-meslo-nerd-font-powerlevel10k"
    fi
}

# 🔧 Verificar configuración de root
verify_root_config() {
    log "Verificando configuración de root..."
    
    # Verificar Oh My Zsh
    if [ -d "/root/.oh-my-zsh" ]; then
        success "✓ Oh My Zsh está instalado en /root/.oh-my-zsh"
        
        # Verificar Powerlevel10k
        if [ -d "/root/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
            success "✓ Powerlevel10k está instalado para root"
        else
            warn "⚠ Powerlevel10k no está instalado para root"
        fi
    else
        warn "⚠ Oh My Zsh no está instalado en root"
    fi
    
    # Verificar symlinks de configuración
    local symlinks=(
        "/root/.zshrc:$CONFIG_DIR/zshrc.template"
        "/root/.p10k.zsh:$CONFIG_DIR/p10k.zsh.template"
        "/root/.bashrc:$CONFIG_DIR/bashrc.template"
        "/root/.nanorc:$CONFIG_DIR/nano_custom/nanorc.conf"
        "/root/.config/fastfetch:$CONFIG_DIR/fastfetch"
        "/root/.config/kitty:$CONFIG_DIR/kitty"
    )
    
    for symlink_pair in "${symlinks[@]}"; do
        IFS=':' read -r symlink source <<< "$symlink_pair"
        
        if [ -L "$symlink" ]; then
            local target=$(readlink "$symlink")
            if [ "$target" = "$source" ]; then
                success "✓ $symlink → $source"
            else
                warn "⚠ $symlink apunta a: $target (esperado: $source)"
            fi
        elif [ -e "$symlink" ]; then
            warn "⚠ $symlink existe pero no es un symlink"
        else
            warn "⚠ $symlink no existe"
        fi
    done
    
    # Verificar directorios
    local dirs=(
        "/root/.config"
        "/root/.zsh"
        "/root/.nano/backups"
    )
    
    for dir in "${dirs[@]}"; do
        if [ -d "$dir" ]; then
            success "✓ Directorio existe: $dir"
        else
            warn "⚠ Directorio no existe: $dir"
        fi
    done
    
    # Verificar permisos
    local dirs_to_check=(
        "/root/.config"
        "/root/.zsh"
        "/root/.oh-my-zsh"
    )
    
    for dir in "${dirs_to_check[@]}"; do
        if [ -d "$dir" ]; then
            local owner=$(stat -c '%U' "$dir" 2>/dev/null || echo "unknown")
            local perms=$(stat -c '%a' "$dir" 2>/dev/null || echo "000")
            
            if [ "$owner" = "root" ]; then
                success "✓ $dir: propietario correcto (root)"
            else
                warn "⚠ $dir: propietario incorrecto ($owner)"
            fi
            
            if [ "$perms" = "700" ]; then
                success "✓ $dir: permisos correctos (700)"
            else
                warn "⚠ $dir: permisos incorrectos ($perms)"
            fi
        fi
    done
}

# 📋 Mostrar ayuda
show_help() {
    cat << EOF
🔍 Arch Dream Machine - Verificador de Integridad

Uso: $0 [OPCIONES]

Opciones:
  -h, --help           Mostrar esta ayuda
  --files              Solo verificar archivos críticos
  --permissions        Solo verificar permisos
  --dependencies       Solo verificar dependencias
  --symlinks           Solo verificar symlinks
  --zsh                Solo verificar configuración Zsh
  --fonts              Solo verificar fuentes
  --root               Solo verificar configuración de root
  --all                Verificar todo (por defecto)

Ejemplos:
  $0                    # Verificar todo
  $0 --files           # Solo archivos
  $0 --symlinks        # Solo symlinks
  $0 --root            # Solo configuración de root

EOF
}

# 🔧 Procesar argumentos
process_args() {
    local check_files=true
    local check_permissions=true
    local check_dependencies=true
    local check_symlinks=true
    local check_zsh=true
    local check_fonts=true
    local check_root=false
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            --files)
                check_permissions=false
                check_dependencies=false
                check_symlinks=false
                check_zsh=false
                check_fonts=false
                shift
                ;;
            --permissions)
                check_files=false
                check_dependencies=false
                check_symlinks=false
                check_zsh=false
                check_fonts=false
                shift
                ;;
            --dependencies)
                check_files=false
                check_permissions=false
                check_symlinks=false
                check_zsh=false
                check_fonts=false
                shift
                ;;
            --symlinks)
                check_files=false
                check_permissions=false
                check_dependencies=false
                check_zsh=false
                check_fonts=false
                shift
                ;;
            --zsh)
                check_files=false
                check_permissions=false
                check_dependencies=false
                check_symlinks=false
                check_fonts=false
                shift
                ;;
            --fonts)
                check_files=false
                check_permissions=false
                check_dependencies=false
                check_symlinks=false
                check_zsh=false
                shift
                ;;
            --root)
                check_files=false
                check_permissions=false
                check_dependencies=false
                check_symlinks=false
                check_zsh=false
                check_fonts=false
                check_root=true
                shift
                ;;
            *)
                error "Opción desconocida: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Ejecutar verificaciones seleccionadas
    local exit_code=0
    
    if [[ "$check_files" == true ]]; then
        verify_files || exit_code=1
        echo
    fi
    
    if [[ "$check_permissions" == true ]]; then
        verify_permissions || exit_code=1
        echo
    fi
    
    if [[ "$check_dependencies" == true ]]; then
        verify_dependencies || exit_code=1
        echo
    fi
    
    if [[ "$check_symlinks" == true ]]; then
        verify_symlinks || exit_code=1
        echo
    fi
    
    if [[ "$check_zsh" == true ]]; then
        verify_zsh_config || exit_code=1
        echo
    fi
    
    if [[ "$check_fonts" == true ]]; then
        verify_fonts || exit_code=1
        echo
    fi
    
    if [[ "$check_root" == true ]]; then
        verify_root_config || exit_code=1
        echo
    fi
    
    # Resumen final
    echo "🎯 Resumen de verificación:"
    if [ $exit_code -eq 0 ]; then
        success "Todas las verificaciones pasaron exitosamente."
    else
        warn "Algunas verificaciones fallaron. Revisa los detalles arriba."
    fi
    
    exit $exit_code
}

# 🏁 Main
main() {
    echo -e "${BOLD}🔍 Verificador de Integridad - Arch Dream Machine${RESET}"
    echo "=================================================="
    echo
    
    process_args "$@"
}

main "$@" 