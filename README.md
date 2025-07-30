
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
  <img src="./fastfetch/Dreamcoder01.jpg" alt="Preview Terminal" width="450" />
  <img src="./fastfetch/Dreamcoder02.jpg" alt="Preview Fastfetch" width="400" />
  <br>
  <i>⚙️ Experiencia visual futurista directamente en tu terminal</i>
</p>

---

## 🔥 ¿Qué es ARCH DREAM MACHINE?

**ARCH DREAM MACHINE** es más que una configuración de Zsh. Es una arquitectura visual + funcional pensada para devs creativos como tú. Un ecosistema completo, ligero, moderno, rápido, y listo para usar.

---

## ✨ Características Principales

| 🧩 Core | 🎨 Estética Pro | 🚀 Nuevas Funciones |
|--------|-----------------|-------------------|
| Zsh + Oh My Zsh | Sugerencias inteligentes y resaltado en tiempo real | Funciones de productividad avanzadas |
| Powerlevel10k | Tema totalmente personalizable y ultra rápido | Smart cd con preview automático |
| Kitty Terminal | Aceleración GPU, hermoso y versátil | Editor de archivos con FZF |
| Bat, eza, fd, rg | Reemplazos modernos para tus comandos CLI | Sistema de notas integrado |
| Fastfetch | Info del sistema, pero con flow Catppuccin | Gestión de Docker y Git Worktrees |
| **AUR Support** | **Yay/Paru integration** | **Bash Fallback incluido** |

---

## 🚀 Nuevas Funciones de Productividad

| Función | Descripción | Ejemplo |
|---------|-------------|---------|
| `fe <pattern>` | Editor de archivos con FZF/búsqueda | `fe config` |
| `note [texto]` | Sistema de notas rápido | `note "Idea importante"` |
| `pskill <proceso>` | Buscar y terminar procesos | `pskill chrome` |
| `gw <comando>` | Gestión de Git Worktrees | `gw add feature-branch` |
| `dk <comando>` | Comandos Docker simplificados | `dk ps`, `dk clean` |
| `serve [puerto]` | Servidor HTTP rápido | `serve 3000` |
| `weather [ciudad]` | Información del clima | `weather "New York"` |
| `cleanup_system` | Limpieza completa del sistema | Interactivo con confirmación |
| `netdiag` | Diagnóstico de red completo | Prueba conectividad y DNS |
| Smart `cd` | CD con preview automático | `cd` muestra contenido si <20 archivos |

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
bash <(curl -fsSL https://raw.githubusercontent.com/dreamcoder08/arch-dream-machine/main/install.sh)
```

### 🛠 Instalación con opciones:

```bash
git clone https://github.com/dreamcoder08/arch-dream-machine.git
cd arch-dream-machine
chmod +x install.sh

# Instalación normal
./install.sh

# Simulación (dry-run)
./install.sh --dry-run

# Sin AUR helper
./install.sh --no-aur

# Instalación mínima
./install.sh --minimal

# Ver todas las opciones
./install.sh --help
```

🔁 **Reinicia tu terminal** para aplicar los cambios.

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
├── install.sh
├── zshrc.template
├── p10k.zsh.template
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

* v2.1.0 → Mejoras en colores + docs actualizada
* v2.0.0 → Catppuccin, optimización, manejo de errores
* v1.0.0 → Setup base con Powerlevel10k, Zsh y Kitty

</details>

---

## 🆘 Troubleshooting & Ayuda

<details>
<summary><b>🎨 Tema roto o caracteres extraños</b></summary>

```bash
# Recargar configuración
source ~/.zshrc
exec zsh

# Verificar fuentes instaladas
fc-list | grep -i nerd

# Reinstalar tema Powerlevel10k
p10k configure
```

</details>

<details>
<summary><b>🧩 Fuentes rotas o íconos faltantes</b></summary>

```bash
# Instalar fuentes Nerd completas
sudo pacman -S ttf-fira-code-nerd ttf-meslo-nerd ttf-sourcecodepro-nerd

# Verificar terminal soporta fuentes
echo -e "\ue0b0 \u00b1 \ue0a0 \u27a6 \u2718 \u26a1 \u2699"

# Actualizar cache de fuentes
fc-cache -fv
```

</details>

<details>
<summary><b>🐢 Terminal lento o lag</b></summary>

```bash
# Diagnóstico de rendimiento
zsh -xvs

# Deshabilitar plugins problemáticos temporalmente
# Edita ~/.zshrc y comenta plugins en la línea: plugins=(...)

# Verificar Oh My Zsh
omz doctor

# Limpiar cache de completions
rm -rf ~/.zsh/cache/*
```

</details>

<details>
<summary><b>🔧 Oh My Zsh no funciona</b></summary>

```bash
# Reinstalar Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Verificar instalación
ls -la ~/.oh-my-zsh/

# Reinstalar Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

</details>

<details>
<summary><b>⚠️ Errores de permisos</b></summary>

```bash
# Verificar permisos de archivos de configuración
ls -la ~/.zshrc ~/.p10k.zsh

# Corregir permisos si es necesario
chmod 644 ~/.zshrc ~/.p10k.zsh
chown $USER:$USER ~/.zshrc ~/.p10k.zsh

# Verificar permisos sudo
sudo -v
```

</details>

<details>
<summary><b>🚫 Comandos no encontrados</b></summary>

```bash
# Verificar PATH
echo $PATH

# Reinstalar herramientas faltantes
sudo pacman -S bat eza fd ripgrep fzf

# Verificar aliases
which ls ll cat grep find
```

</details>

<details>
<summary><b>🔄 Desinstalar completamente</b></summary>

```bash
# Remover symlinks
rm ~/.zshrc ~/.p10k.zsh ~/.nanorc
rm -rf ~/.config/fastfetch ~/.config/kitty

# Restaurar configuraciones originales
mv ~/.config_backup_*/.[!.]* ~/  # Restaurar desde backup más reciente

# Opcional: Remover Oh My Zsh
rm -rf ~/.oh-my-zsh
```

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


