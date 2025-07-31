
<h1 align="center" style="font-family: 'Fira Code', monospace; font-weight: bold; font-size: 3.5rem;">
  🌌 <span style="color:#7dcfff;">ARCH DREAM MACHINE</span> 🌌
</h1>

<p align="center">
  <img src="https://img.shields.io/badge/Built%20With-Zsh%20|%20Powerlevel10k%20|%20Kitty%20|%20Fastfetch-blueviolet?style=for-the-badge&logo=arch-linux&logoColor=white" />
</p>

<p align="center">
  <a href="https://github.com/dreamcoder08/arch-dream-machine/stargazers">
    <img src="https://img.shields.io/github/stars/dreamcoder08/arch-dream-machine?style=flat-square&color=ffd700" alt="Stars">
  </a>
  <a href="https://github.com/dreamcoder08/arch-dream-machine/issues">
    <img src="https://img.shields.io/github/issues/dreamcoder08/arch-dream-machine?style=flat-square&color=red" alt="Issues">
  </a>
  <a href="https://github.com/dreamcoder08/arch-dream-machine/network">
    <img src="https://img.shields.io/github/forks/dreamcoder08/arch-dream-machine?style=flat-square&color=blue" alt="Forks">
  </a>
  <a href="LICENSE">
    <img src="https://img.shields.io/github/license/dreamcoder08/arch-dream-machine?style=flat-square&color=00e676" alt="License">
  </a>
</p>

---

> 🧠 *"Imagina un entorno terminal que no solo funcione... sino que te inspire."*  
> 💻 Este script transforma Arch Linux en una obra de arte funcional.  
> ⚡ Un solo comando. Una nueva era para tu terminal.

---

## 🖼️ Preview

<p align="center">
  <img src="fastfetch/Dreamcoder01.jpg" alt="Arch Dream Machine Preview" width="850" />
  <br>
  <i>⚙️ Experiencia visual futurista directamente en tu terminal</i>
</p>

---

## 🔥 ¿Qué es ARCH DREAM MACHINE?

**ARCH DREAM MACHINE** es más que una configuración de Zsh. Es una arquitectura visual + funcional pensada para devs creativos como tú. Un ecosistema completo, ligero, moderno, rápido, y listo para usar.

---

## ✨ Características Principales

| 🧩 Core | 🎨 Estética Pro |
|--------|-----------------|
| Zsh + Oh My Zsh | Sugerencias inteligentes y resaltado en tiempo real |
| Powerlevel10k | Tema totalmente personalizable y ultra rápido |
| Kitty Terminal | Aceleración GPU, hermoso y versátil |
| Bat, eza, fd, rg | Reemplazos modernos para tus comandos CLI |
| Fastfetch | Info del sistema, pero con flow Catppuccin |

---

## 🧰 Plugins y Herramientas Incluidas

| Categoría | Herramientas | Propósito |
|----------|--------------|-----------|
| Shell Enhancements | `zsh-autosuggestions`, `zsh-syntax-highlighting` | UX inteligente en consola |
| Arch CLI Suite | `bat`, `eza`, `fd`, `rg` | Flujo ágil de búsqueda, lectura y exploración |
| Monitorización | `btop`, `dust`, `duf` | Métricas limpias y visuales en tiempo real |
| Networking | `xh` | Reemplazo moderno de `curl` |
| Terminal | `kitty` | El emulador más poderoso del juego |

---

## 🚀 Instalación Express

### ☄️ Un solo comando:

```bash
# Instalación normal (solo usuario)
bash <(curl -fsSL https://raw.githubusercontent.com/dreamcoder08/arch-dream-machine/main/install.sh)

# Instalación + configuración automática de root
sudo bash <(curl -fsSL https://raw.githubusercontent.com/dreamcoder08/arch-dream-machine/main/install.sh)
```

### 🛠 Manual (alternativa):

```bash
git clone https://github.com/dreamcoder08/arch-dream-machine.git
cd arch-dream-machine
chmod +x install.sh

# Instalación normal (solo usuario)
./install.sh

# Instalación + configuración automática de root
sudo ./install.sh
```

### 🔧 Opciones de instalación:

```bash
# Modo simulación (no hacer cambios reales)
./install.sh --dry-run

# Solo paquetes oficiales (sin AUR)
./install.sh --no-aur

# Saltar verificación de integridad
./install.sh --no-verify

# Saltar backup de configuraciones existentes
./install.sh --skip-backup
```

🔁 **Reinicia tu terminal** para aplicar los cambios.

## 🔧 Configuración de Root

Para que el usuario root tenga la misma configuración que tu usuario normal:

### 🚀 Configuración Automática (Recomendado)
```bash
# Instalación normal + configuración automática de root
sudo ./install.sh
```

### 🔧 Configuración Manual
```bash
# Instalar + configurar root manualmente
sudo ./install.sh --setup-root
```

### 🎯 ¿Cómo funciona?
- **Ejecución con sudo:** El script detecta automáticamente que se ejecuta como root y configura el entorno
- **Ejecución normal:** Solo configura tu usuario, no afecta root
- **Opción manual:** Puedes forzar la configuración de root con `--setup-root`

### 📋 Después de ejecutar el script:
1. Ejecuta `sudo su` para cambiar a root
2. La configuración se cargará automáticamente
3. Si no se carga, ejecuta `source ~/.zshrc`

**Nota:** El script configura Oh My Zsh, Powerlevel10k y todos los archivos de configuración para root.

### Desinstalar configuración de root:
```bash
# Desinstalar configuración de root
sudo ./uninstall.sh --remove-root
```

### Verificar configuración de root:
```bash
# Verificar configuración de root
./verify.sh --root
```

## 🗑️ Desinstalación

### Desinstalación básica (solo symlinks):
```bash
./uninstall.sh
```

### Desinstalación completa:
```bash
./uninstall.sh --remove-packages --remove-ohmyzsh
```

### Modo simulación:
```bash
./uninstall.sh --dry-run
```

## 🔍 Verificación

### Verificar integridad del proyecto:
```bash
./verify.sh
```

### Verificar solo archivos críticos:
```bash
./verify.sh --files
```

### Verificar configuración actual:
```bash
./verify.sh --symlinks --zsh --fonts
```

---

## 🧪 Personalización Total

| Elemento      | Archivo                            | Acción                      |
| ------------- | ---------------------------------- | --------------------------- |
| Powerlevel10k | `~/.p10k.zsh`                      | `p10k configure`            |
| Zsh Settings  | `~/.zshrc`                         | Edita, ajusta y reconfigura |
| Kitty         | `~/.config/kitty/kitty.conf`       | Incluye tus temas favoritos |
| Fastfetch     | `~/.config/fastfetch/config.jsonc` | Personaliza el banner info  |

---

## 🎨 Temas y Colores

<details>
<summary><b>🎨 Cambiar tema en Bat</b></summary>

```bash
bat --list-themes
export BAT_THEME="Catppuccin Mocha" # Agrega en tu ~/.zshrc
```

</details>

<details>
<summary><b>🎨 Cambiar tema en Kitty</b></summary>

Incluye tu color personalizado en el `kitty.conf`:

```bash
include ./themes/colors-dreamcoder.conf
```

</details>

---

## 🗂 Estructura del Proyecto

```bash
arch-dream-machine/
├── README.md
├── install.sh              # Script de instalación principal
├── uninstall.sh            # Script de desinstalación
├── verify.sh               # Verificador de integridad
├── zshrc.template          # Configuración de Zsh
├── p10k.zsh.template       # Configuración de Powerlevel10k
├── bashrc.template         # Configuración de Bash (fallback)
├── fastfetch/
│   ├── config.jsonc
│   ├── Dreamcoder01.jpg
│   ├── Dreamcoder02.jpg
│   ├── Dreamcoder03.jpg
│   └── Dreamcoder04.jpg
├── kitty/
│   ├── kitty.conf
│   └── colors-dreamcoder.conf
└── nano_custom/
    └── nanorc.conf
```

---

## 🧠 Tips Avanzados

<details>
<summary><b>⏱ Acelera Zsh</b></summary>

```bash
DISABLE_UNTRACKED_FILES_DIRTY="true"
COMPLETION_WAITING_DOTS="true"
HISTSIZE=50000
SAVEHIST=50000
```

</details>

<details>
<summary><b>⚙️ Agrega tus plugins</b></summary>

```bash
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  your-plugin-here
)
```

</details>

## 🚀 Nuevas Funciones de Productividad

### 📝 Notas y Tareas
```bash
note "Mi nota rápida"     # Agregar nota al archivo del día
note                     # Abrir editor de notas
todo "Nueva tarea"       # Agregar tarea al todo
todo                     # Abrir editor de tareas
```

### 🔧 Utilidades del Sistema
```bash
sysupdate               # Actualizar sistema + AUR
sysclean                # Limpiar sistema
sysstat                 # Información del sistema
passgen 16              # Generar contraseña de 16 caracteres
```

### 📁 Gestión de Archivos
```bash
newproj mi-proyecto     # Crear y entrar a directorio
dirsize /ruta           # Tamaño de directorio
findext py              # Buscar archivos por extensión
countext js             # Contar archivos por extensión
search "texto"          # Buscar texto en archivos
```

### 🧮 Herramientas Rápidas
```bash
calc "2 + 2 * 3"        # Calculadora
shorten "https://..."   # Acortar URL
qr "texto"              # Generar código QR
```

### 🔄 Git Avanzado
```bash
gac "commit message"    # Add + commit
gacp "commit message"   # Add + commit + push
gundo                   # Deshacer último commit
gamend                  # Amendar último commit
```

---

## 🆘 Troubleshooting Detallado

### 🚨 Problemas Comunes y Soluciones

<details>
<summary><b>🎨 Tema roto o Powerlevel10k no funciona</b></summary>

**Síntomas:** Prompt básico, sin iconos, colores planos

**Soluciones:**
```bash
# 1. Verificar instalación de Oh My Zsh
ls -la ~/.oh-my-zsh

# 2. Reinstalar Powerlevel10k
rm -rf ~/.oh-my-zsh/custom/themes/powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k

# 3. Recargar configuración
source ~/.zshrc

# 4. Reconfigurar Powerlevel10k
p10k configure
```

</details>

<details>
<summary><b>🔤 Fuentes Nerd Font rotas</b></summary>

**Síntomas:** Iconos como cuadrados o caracteres extraños

**Soluciones:**
```bash
# 1. Instalar fuentes Nerd Font
sudo pacman -S ttf-meslo-nerd-font-powerlevel10k

# 2. Configurar fuente en Kitty
# Edita ~/.config/kitty/kitty.conf y asegúrate de tener:
font_family MesloLGS NF

# 3. Reiniciar terminal
# Cierra y abre una nueva ventana de Kitty
```

</details>

<details>
<summary><b>🐢 Terminal lento o lag</b></summary>

**Síntomas:** Comandos lentos, delay en el prompt

**Soluciones:**
```bash
# 1. Verificar plugins conflictivos
zsh -xvs

# 2. Deshabilitar plugins temporalmente
# Edita ~/.zshrc y comenta plugins problemáticos

# 3. Optimizar configuración
echo 'DISABLE_UNTRACKED_FILES_DIRTY="true"' >> ~/.zshrc
echo 'COMPLETION_WAITING_DOTS="true"' >> ~/.zshrc

# 4. Limpiar cache de Zsh
rm -rf ~/.zsh/cache
```

</details>

<details>
<summary><b>❌ Error de permisos o symlinks</b></summary>

**Síntomas:** "Permission denied", "No such file or directory"

**Soluciones:**
```bash
# 1. Verificar permisos del script
chmod +x install.sh

# 2. Ejecutar con sudo si es necesario
sudo ./install.sh

# 3. Verificar symlinks
ls -la ~/.zshrc ~/.p10k.zsh

# 4. Recrear symlinks manualmente
ln -sf /ruta/al/proyecto/zshrc.template ~/.zshrc
ln -sf /ruta/al/proyecto/p10k.zsh.template ~/.p10k.zsh
```

</details>

<details>
<summary><b>🌐 Problemas de conectividad</b></summary>

**Síntomas:** "Connection refused", "Could not resolve host"

**Soluciones:**
```bash
# 1. Verificar conexión a internet
ping -c 3 archlinux.org

# 2. Verificar DNS
nslookup github.com

# 3. Configurar DNS alternativo
echo "nameserver 8.8.8.8" | sudo tee -a /etc/resolv.conf

# 4. Usar instalación manual si curl falla
git clone https://github.com/dreamcoder08/arch-dream-machine.git
cd arch-dream-machine
./install.sh
```

</details>

<details>
<summary><b>📦 Paquetes no encontrados</b></summary>

**Síntomas:** "Package not found", "Target not found"

**Soluciones:**
```bash
# 1. Actualizar base de datos de paquetes
sudo pacman -Sy

# 2. Verificar repositorios habilitados
sudo pacman -Syy

# 3. Instalar paquetes manualmente
sudo pacman -S zsh fzf bat eza ripgrep

# 4. Verificar paquetes en AUR
yay -S paquete-faltante
# o
paru -S paquete-faltante
```

</details>

### 🔧 Modo Debug

Para obtener información detallada de errores:

```bash
# Ejecutar script en modo verbose
bash -x install.sh

# Ver logs de instalación
cat ~/setup_arch_dream.log

# Verificar estado de instalación
ls -la ~/.oh-my-zsh ~/.p10k.zsh ~/.zshrc
```

### 📞 Soporte Adicional

Si los problemas persisten:

1. **Revisa los logs:** `cat ~/setup_arch_dream.log`
2. **Verifica tu sistema:** `fastfetch` o `neofetch`
3. **Abre un issue:** [GitHub Issues](https://github.com/dreamcoder08/arch-dream-machine/issues)
4. **Incluye información:**
   - Versión de Arch Linux
   - Salida de `fastfetch`
   - Contenido del log de errores
   - Pasos para reproducir el problema

---

## 🤝 Contribuciones

¿Ideas? ¿Errores? ¿Nuevas herramientas?

<details>
<summary><b>🐞 Reportar un bug</b></summary>

* Abre un [issue aquí](https://github.com/dreamcoder08/arch-dream-machine/issues)
* Describe el problema, tu terminal, y cómo reproducirlo.

</details>

<details>
<summary><b>🌱 Proponer mejoras</b></summary>

* ¿Tienes una idea épica? Cuéntala y la integramos.

</details>

<details>
<summary><b>💻 Contribuir con código</b></summary>

1. Haz fork del repo
2. Crea una rama nueva
3. Envía el PR con descripción

</details>

---

## 📜 Changelog

<details>
<summary><b>Ver actualizaciones recientes</b></summary>

* v2.3.0 → Script de desinstalación, verificador de integridad, bash fallback, funciones de productividad
* v2.2.0 → Soporte AUR, verificación de integridad, troubleshooting mejorado
* v2.1.0 → Mejoras en colores + docs actualizada
* v2.0.0 → Catppuccin, optimización, manejo de errores
* v1.0.0 → Setup base con Powerlevel10k, Zsh y Kitty

</details>

---

## 🙌 Créditos

Inspirado por:

* [Oh My Zsh](https://ohmyz.sh/)
* [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
* [Catppuccin](https://catppuccin.com/)
* Comunidad Arch Linux

---

## 🧾 Licencia

**MIT License** © 2024 **𓂀 Dreamcoder08 𓂀**

Hecho con 💜 para devs que viven el terminal como un arte.

<p align="center">
  <sub>¿Te gustó? Deja una ⭐ en el repo y comparte el poder del terminal bien tuneado</sub><br><br>
  <a href="https://github.com/dreamcoder08/arch-dream-machine/stargazers">
    <img src="https://img.shields.io/github/stars/dreamcoder08/arch-dream-machine?style=social" />
  </a>
</p>


