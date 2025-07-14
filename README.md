# Zsh Custom Configuration

This project automates the setup of a personalized Zsh environment, including Powerlevel10k and Fastfetch configurations.

## Installation

To install, run the following command:

```bash
./install.sh
```

The script will:

1.  Check for dependencies (Zsh, Git, Fastfetch).
2.  Create backups of your existing configurations in `~/.config_backup_YYYYMMDD_HHMMSS`.
3.  Install Oh My Zsh and the Powerlevel10k theme if they are not already present.
4.  Create symbolic links from your home directory to the configuration files in this project.

## Structure

*   `install.sh`: The installation script.
*   `zshrc.template`: Your `.zshrc` configuration.
*   `p10k.zsh.template`: Your Powerlevel10k configuration.
*   `fastfetch/`: Your Fastfetch configuration files.

## Customization

To customize your configuration, edit the template files in this directory. The changes will be reflected in your environment after you restart your shell.
