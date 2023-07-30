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

# Function to install Homebrew
install_homebrew() {
  command -v brew >/dev/null 2>&1 || {
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  }

  # Ensure that git is setup with a name and email
  git config --global user.email "$GIT_EMAIL"
  git config --global user.name "$GIT_NAME"
}

# Function to install oh-my-zsh
install_ohmyzsh() {
  git clone https://github.com/ohmyzsh/ohmyzsh.git "$TARGET_DIR/.oh-my-zsh"
}

# Execute the installation steps
main() {
  # Step 1: Symlink dotfiles
  symlink_dotfiles || {
    echo "Failed to symlink dotfiles"
    exit 1
  }

  # Step 2: Install Homebrew
  if command -v brew >/dev/null 2>&1; then
    echo "Homebrew is already installed."
  else
    install_homebrew || {
      echo "Failed to install Homebrew"
      exit 1
    }
  fi

  # Step 3: Install Oh My Zsh
  install_ohmyzsh || {
    echo "Failed to install Oh My Zsh"
    exit 1
  }
}

# Set error handling
set -e

# Invoke the main function
main "$@"
