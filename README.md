# Dotfiles Installation Guide

This guide helps you install your dotfiles using [GNU Stow](https://www.gnu.org/software/stow/). It also covers installing dependencies via Homebrew (macOS) or your Linux package manager.

## Prerequisites

### macOS

1. **Install Homebrew** (if not already installed):
    ```sh
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ```
2. **Install Stow**:
    ```sh
    brew install stow
    ```

### Linux

1. **Install Stow** (Debian/Ubuntu):
    ```sh
    sudo apt update
    sudo apt install stow
    ```
    **Fedora:**
    ```sh
    sudo dnf install stow
    ```
    **Arch:**
    ```sh
    sudo pacman -S stow
    ```

## Installing Dotfiles

1. **Clone your dotfiles repository:**
    ```sh
    git clone https://github.com/trinhminh11/dotfiles.git ~/dotfiles
    cd ~/dotfiles
    ```

2. **Use Stow to symlink configuration files:**
    ```sh
    stow <package>
    ```
    Replace `<package>` with the folder name (e.g., `bash`, `vim`, `git`, etc.).

    Example:
    ```sh
    stow zsh
    stow aliases
    ```

## Notes

- Each package (e.g., `bash`, `vim`) should be a directory containing config files.
- Stow will symlink files into your home directory.

---

Happy customizing!