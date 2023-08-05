#!/bin/bash

# DEFINE VARIABLES
ZSH_CONFIG_DIR="./zsh_config" # Path to zsh configuration files (if applicable)
CONFIG_DIR="./config_files"   # Path to dotfiles directory
TARGET_DIR="$HOME"            # Target directory for symlinking dotfiles

# git information
GIT_NAME="Martin Cox"
GIT_EMAIL="martincox99@me.com"

# Function to symlink the dotfiles to $HOME
symlink_dotfiles() {
  for file_to_symlink in "$CONFIG_DIR"/*; do
    ln -s "$file_to_symlink" "$TARGET_DIR/$(basename "$file_to_symlink")"
  done
}

git_setup() {
  # Ensure that git is setup with a name and email
  git config --global user.email "$GIT_EMAIL"
  git config --global user.name "$GIT_NAME"
}

# Function to install Homebrew
install_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    echo "Homebrew is already installed"
    exit 1
  else
    echo "Homebrew not installed yet, running installation now..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
}

# Function to initialize and update the oh-my-zsh submodule
install_ohmyzsh() {
  git submodule init
  git submodule update
}

# Execute the installation steps
main() {
  # Step 1: Symlink dotfiles
  symlink_dotfiles || {
    echo "Failed to symlink dotfiles"
    exit 1
  }

  # Step 2: Install Homebrew
  install_homebrew || {
    echo "Failed to install Homebrew"
    exit 1
  }

  # Step 3: Install Oh My Zsh
  install_ohmyzsh || {
    echo "Failed to initialize or update Oh My Zsh"
    exit 1
  }
}

# Set error handling
set -e

# Invoke the main function
main "$@"
