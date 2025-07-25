# 🚀 ARCH DREAM MACHINE

![Built With](https://img.shields.io/badge/Built%20With-Zsh%20%7C%20Oh%20My%20Zsh%20%7C%20Powerlevel10k%20%7C%20Kitty%20%7C%20Bat%20%7C%20Fastfetch-blueviolet?style=for-the-badge&logo=zsh&logoColor=white)
## 📸 Vistas Previas
<img width="945" height="769" alt="image" src="https://github.com/user-attachments/assets/a4e9b4b8-1017-48aa-923b-68051a456596" />

> 🛠️ Creado con 💙 por: 𓂀 `Dreamcoder08` 𓂀

## ✨ Descripción

**ARCH DREAM MACHINE** es un script de configuración minimalista y potente diseñado para transformar y personalizar tu entorno de línea de comandos en **Arch Linux** y sus derivados. Este script automatiza la configuración de un shell Zsh altamente optimizado, proporcionando una experiencia de terminal moderna, eficiente y visualmente atractiva desde el primer momento.

### Incluye:

-   **Zsh + Oh My Zsh:** Un framework robusto para la gestión de tu configuración de Zsh.
-   **Powerlevel10k:** Un tema increíblemente rápido y personalizable para Zsh, con un aspecto visual impresionante.
-   **Plugins Esenciales:**
    -   `zsh-autosuggestions`: Sugerencias de comandos basadas en tu historial (cargado directamente).
    -   `zsh-syntax-highlighting`: Resaltado de sintaxis para comandos en tiempo real (cargado directamente).
    -   Completions mejoradas: Autocompletación avanzada para comandos y argumentos.
-   **Kitty Terminal:** Configuración optimizada con temas personalizados para una experiencia visual superior.
-   **Bat:** Un `cat` con superpoderes, con resaltado de sintaxis y paginación, integrado con temas Catppuccin.
-   **Fastfetch Personalizado:** Una herramienta de información del sistema rápida y estéticamente agradable.
-   **Herramientas Modernas de CLI:** Un conjunto de utilidades de línea de comandos de última generación para maximizar tu productividad diaria (e.g., `eza`, `rg`, `fd`, `duf`, `dust`, `btop`, `xh`).

## 🎨 Características

✅ Instalación automática de dependencias vía pacman, asegurando que tengas todo lo necesario.

✅ Respaldo seguro de tus configuraciones anteriores, para que nunca pierdas tus archivos importantes.

✅ Instalación sin esfuerzo de Oh My Zsh y Powerlevel10k, listo para usar.

✅ Creación inteligente de enlaces simbólicos para configuraciones personalizadas, manteniendo tu HOME limpio.

✅ Interfaz interactiva con un banner gráfico y un spinner animado para una experiencia de usuario agradable.
## ⚙️ Requisitos

Para ejecutar **ARCH DREAM MACHINE**, asegúrate de tener:

-   **Arch Linux** o una distribución derivada (Manjaro, EndeavourOS, etc.).
-   `sudo` configurado y permisos para instalar paquetes.

## 🚀 Instalación

Sigue estos Spasos para poner en marcha tu **ARCH DREAM MACHINE**:

1.  **Clona el repositorio:**

    ```bash
    git clone https://github.com/Albert-fer02/zsh_custom_config.git
    ```

2.  **Navega al directorio del proyecto:**

    ```bash
    cd zsh_custom_config
    ```

3.  **Haz el script ejecutable:**

    ```bash
    chmod +x install.sh
    ```

4.  **Ejecuta el script de instalación:**

    ```bash
    ./install.sh
    ```

    > ⚡ **¡Importante!** Al finalizar la instalación, **reinicia tu terminal** (cierra y vuelve a abrir) para que todos los cambios surtan efecto y disfrutes de tu nuevo entorno.

## 🛠️ Uso y Personalización

Una vez instalado, tu entorno estará listo para usar. Puedes personalizar aún más tu configuración editando los siguientes archivos:

-   `~/.zshrc`: El archivo principal de configuración de Zsh. Aquí puedes añadir tus alias, funciones y variables de entorno. Este archivo es un enlace simbólico a `zshrc.template` en este repositorio.

-   `~/.p10k.zsh`: El archivo de configuración de Powerlevel10k. Ejecuta `p10k configure` en tu terminal para iniciar el asistente de configuración visual y adaptar el tema a tu gusto. Este archivo es un enlace simbólico a `p10k.zsh.template` en este repositorio.

-   `~/.config/fastfetch/config.jsonc`: Personaliza la salida de `fastfetch` editando este archivo JSON. Es un enlace simbólico a `fastfetch/config.jsonc` en este repositorio.

-   `~/.config/kitty/kitty.conf`: Configura tu terminal Kitty. Este archivo es un enlace simbólico a `kitty/kitty.conf` en este repositorio. Puedes cambiar el tema incluyendo otro archivo de la carpeta `kitty/themes/`.

-   `BAT_THEME`: Para cambiar el tema de `bat`, edita la variable `BAT_THEME` en tu `~/.zshrc` (o `zshrc.template`) con el nombre exacto del tema (ej. `export BAT_THEME="Catppuccin Macchiato"`). Puedes ver los temas disponibles con `bat --list-themes`.

## 🗂️ Estructura del Proyecto

```
arch-dream-machine/
│
├── install.sh           # Script principal de instalación y configuración.
├── zshrc.template       # Plantilla base para la configuración de Zsh (~/.zshrc).
├── p10k.zsh.template    # Plantilla de configuración para Powerlevel10k (~/.p10k.zsh).
├── fastfetch/           # Directorio que contiene la configuración personalizada de Fastfetch.
│   └── config.jsonc     # Archivo de configuración de Fastfetch.
└── kitty/               # Directorio que contiene la configuración de Kitty.
    ├── kitty.conf       # Archivo de configuración principal de Kitty.
```

## 🤝 Contribución

¡Las contribuciones son bienvenidas! Si tienes ideas para mejorar, encuentras un error o quieres añadir nuevas funcionalidades, por favor:

-   Haz un "fork" de este repositorio.
-   Crea una nueva rama (`git checkout -b feature/AmazingFeature`).
-   Realiza tus cambios y haz "commit" (`git commit -m 'Add some AmazingFeature'`).
-   Sube tus cambios (`git push origin feature/AmazingFeature`).
-   Abre un "Pull Request".


## 🧿 Licencia

Este proyecto está bajo la Licencia MIT. Consulta el archivo `LICENSE` para más detalles.

MIT License © 𓂀 `dreamcoder08`

---

> Crafted with passion for customization lovers 💻✨

> ¡Si te gusta este proyecto, por favor considera darle una estrella ⭐ en GitHub!

