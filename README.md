
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
  <img src="https://github.com/user-attachments/assets/0fbf24bb-253b-46c8-a92b-c1406cfee2ba" alt="Preview" width="850" />
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
bash <(curl -fsSL https://raw.githubusercontent.com/dreamcoder08/arch-dream-machine/main/install.sh)
````

### 🛠 Manual (alternativa):

```bash
git clone https://github.com/dreamcoder08/arch-dream-machine.git
cd arch-dream-machine
chmod +x install.sh
./install.sh
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

## 🆘 Ayuda rápida

<details>
<summary><b>🎨 Tema roto</b></summary>

```bash
source ~/.zshrc
# o simplemente reinicia
```

</details>

<details>
<summary><b>🧩 Fuentes rotas</b></summary>

```bash
sudo pacman -S ttf-meslo-nerd
```

</details>

<details>
<summary><b>🐢 Terminal lento</b></summary>

```bash
zsh -xvs # Revisa plugins en conflicto
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


