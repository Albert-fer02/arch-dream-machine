# 🌟 ARCH DREAM MACHINE

<div align="center">

![Built With](https://img.shields.io/badge/Built%20With-Zsh%20%7C%20Oh%20My%20Zsh%20%7C%20Powerlevel10k%20%7C%20Kitty%20%7C%20Bat%20%7C%20Fastfetch-blueviolet?style=for-the-badge&logo=zsh&logoColor=white)

[![GitHub Stars](https://img.shields.io/github/stars/Albert-fer02/zsh_custom_config?style=flat-square&color=ffd700)](https://github.com/Albert-fer02/zsh_custom_config/stargazers)
[![GitHub Issues](https://img.shields.io/github/issues/Albert-fer02/zsh_custom_config?style=flat-square&color=red)](https://github.com/Albert-fer02/zsh_custom_config/issues)
[![GitHub Forks](https://img.shields.io/github/forks/Albert-fer02/zsh_custom_config?style=flat-square&color=blue)](https://github.com/Albert-fer02/zsh_custom_config/network)
[![License](https://img.shields.io/github/license/Albert-fer02/zsh_custom_config?style=flat-square&color=green)](LICENSE)

**Transform your terminal into a modern, powerful development environment**

*One script to rule them all* ✨

</div>

---

## 🎨 Preview

<div align="center">
<img width="946" height="817" alt="image" src="https://github.com/user-attachments/assets/0fbf24bb-253b-46c8-a92b-c1406cfee2ba" />


*Experience the future of terminal aesthetics*
</div>

---

## 🚀 What is ARCH DREAM MACHINE?

**ARCH DREAM MACHINE** is a meticulously crafted, one-click terminal transformation script designed for **Arch Linux** enthusiasts who refuse to settle for mediocrity. This isn't just another dotfiles repository—it's a complete terminal ecosystem that bridges the gap between functionality and beauty.

### 🎯 Philosophy

Born from the belief that your development environment should inspire creativity, not hinder it. Every configuration choice has been carefully curated to provide maximum productivity while maintaining visual elegance.

---

## ✨ Features at a Glance

<table>
<tr>
<td width="50%">

### 🔧 **Core Components**
- **Zsh + Oh My Zsh** - Robust shell framework
- **Powerlevel10k** - Lightning-fast, customizable theme
- **Kitty Terminal** - GPU-accelerated terminal emulator
- **Bat** - Cat with syntax highlighting superpowers
- **Fastfetch** - System information with style

</td>
<td width="50%">

### 🎨 **Enhanced Experience**
- **Smart Autosuggestions** - AI-like command predictions
- **Syntax Highlighting** - Real-time command validation
- **Modern CLI Tools** - Next-gen utilities (eza, rg, fd, etc.)
- **Catppuccin Themes** - Cohesive color palette across tools
- **Zero Configuration** - Works perfectly out of the box

</td>
</tr>
</table>

---

## 🛠️ Included Tools & Plugins

<div align="center">

| Category | Tools | Purpose |
|----------|-------|---------|
| **Shell Enhancement** | `zsh-autosuggestions`, `zsh-syntax-highlighting` | Smart completions & syntax validation |
| **File Operations** | `eza`, `bat`, `fd`, `rg` | Modern file listing, viewing & searching |
| **System Monitoring** | `btop`, `dust`, `duf` | Resource monitoring & disk usage |
| **Network & HTTP** | `xh` | Modern HTTP client |
| **Terminal Emulator** | `kitty` | GPU-accelerated, feature-rich terminal |

</div>

---

## 📋 Prerequisites

<div align="center">

| Requirement | Status | Note |
|-------------|--------|------|
| **Arch Linux** | ✅ Required | Or Arch-based distros (Manjaro, EndeavourOS) |
| **sudo privileges** | ✅ Required | For package installation |
| **Git** | ✅ Required | Usually pre-installed |
| **Internet connection** | ✅ Required | For downloading dependencies |

</div>

---

## 🚀 Quick Start

### Option 1: One-Line Install (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/Albert-fer02/zsh_custom_config/main/install.sh | bash
```

### Option 2: Manual Installation

```bash
# Clone the repository
git clone https://github.com/Albert-fer02/zsh_custom_config.git

# Navigate to project directory
cd zsh_custom_config

# Make script executable
chmod +x install.sh

# Run the installation
./install.sh
```

### 🔄 Post-Installation

> **⚡ Important:** Restart your terminal after installation to activate all changes.

---

## 🎨 Customization Guide

### 🎯 Quick Customization

| Component | Configuration File | Command to Customize |
|-----------|-------------------|---------------------|
| **Powerlevel10k Theme** | `~/.p10k.zsh` | `p10k configure` |
| **Zsh Settings** | `~/.zshrc` | `nano ~/.zshrc` |
| **Kitty Terminal** | `~/.config/kitty/kitty.conf` | `kitty --config ~/.config/kitty/kitty.conf` |
| **Fastfetch Display** | `~/.config/fastfetch/config.jsonc` | `nano ~/.config/fastfetch/config.jsonc` |

### 🎨 Theme Switching

<details>
<summary><b>Change Bat Theme</b></summary>

1. List available themes:
   ```bash
   bat --list-themes
   ```

2. Set your preferred theme in `~/.zshrc`:
   ```bash
   export BAT_THEME="Catppuccin Mocha"
   ```
</details>

<details>
<summary><b>Kitty Theme Options</b></summary>

Explore themes in `kitty/` directory and include them in your `kitty.conf`:
```bash
include ./colors-dreamcoder.conf
```
</details>

---

## 📁 Project Structure

```
arch-dream-machine/
├── 📜 install.sh              # Main installation script
├── 🔧 zshrc.template          # Zsh configuration template
├── 🎨 p10k.zsh.template       # Powerlevel10k theme configuration
├── 📊 fastfetch/              # System info configuration
│   └── config.jsonc
├── 🖥️  kitty/                 # Terminal emulator settings
│   ├── kitty.conf
│   └── themes/                # Color scheme collection
├── 📚 docs/                   # Documentation
└── 🛡️  LICENSE                # MIT License
```

---

## 🔧 Advanced Configuration

<details>
<summary><b>🎯 Performance Tuning</b></summary>

For optimal performance, consider these tweaks in your `~/.zshrc`:

```bash
# Reduce startup time
DISABLE_UNTRACKED_FILES_DIRTY="true"
COMPLETION_WAITING_DOTS="true"

# Optimize history
HISTSIZE=50000
SAVEHIST=50000
```
</details>

<details>
<summary><b>🔌 Adding Custom Plugins</b></summary>

Add plugins to your `~/.zshrc`:

```bash
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    your-custom-plugin
)
```
</details>

---

## 🤝 Contributing

We welcome contributions from the community! Here's how you can help:

<details>
<summary><b>🐛 Report Issues</b></summary>

Found a bug? Please [open an issue](https://github.com/Albert-fer02/zsh_custom_config/issues) with:
- Your OS version and terminal emulator
- Steps to reproduce the issue
- Expected vs actual behavior
- Screenshots if applicable
</details>

<details>
<summary><b>✨ Suggest Features</b></summary>

Have an idea? We'd love to hear it! Open a [feature request](https://github.com/Albert-fer02/zsh_custom_config/issues) with:
- Clear description of the feature
- Use case and benefits
- Possible implementation approach
</details>

<details>
<summary><b>🔧 Submit Code</b></summary>

Ready to contribute code?

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes and test thoroughly
4. Commit with descriptive messages: `git commit -m 'Add amazing feature'`
5. Push to your fork: `git push origin feature/amazing-feature`
6. Open a Pull Request with a detailed description
</details>

---

## 📝 Changelog

<details>
<summary><b>View Release History</b></summary>

### v2.1.0 - Latest
- 🔧 Fixed Kitty color configuration files.
- 🗑️ Removed theme switching scripts and related configurations.
- 📚 Updated README.md to reflect the changes.

### v2.0.0
- ✨ Added Catppuccin theme integration
- 🚀 Performance optimizations
- 🔧 Improved error handling
- 📚 Enhanced documentation

### v1.5.0
- 🎨 Added Kitty terminal configuration
- 🔌 New CLI tools integration
- 🐛 Bug fixes and stability improvements

### v1.0.0
- 🎉 Initial release
- ⚡ Basic Zsh + Oh My Zsh setup
- 🎨 Powerlevel10k integration
</details>

---

## 🆘 Troubleshooting

<details>
<summary><b>Common Issues & Solutions</b></summary>

### Theme not loading correctly
```bash
# Reload your configuration
source ~/.zshrc

# Or restart your terminal
```

### Fonts looking broken
```bash
# Install required fonts
sudo pacman -S ttf-meslo-nerd
```

### Performance issues
```bash
# Check for conflicting plugins
zsh -xvs
```
</details>

---

## 🙏 Acknowledgments

This project stands on the shoulders of giants. Special thanks to:

- [Oh My Zsh](https://ohmyz.sh/) community
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) by Roman Perepelitsa
- [Catppuccin](https://catppuccin.com/) theme creators
- The Arch Linux community

---

## 📜 License

<div align="center">

**MIT License** © 2024 **𓂀 Dreamcoder08 𓂀**

This project is free and open-source. See [LICENSE](LICENSE) for details.

---

**Made with 💜 by passionate developers, for passionate developers**

<sub>If this project helped you, please consider giving it a ⭐ on GitHub!</sub>

[![GitHub Stars](https://img.shields.io/github/stars/Albert-fer02/zsh_custom_config?style=social)](https://github.com/Albert-fer02/zsh_custom_config/stargazers)

</div>
