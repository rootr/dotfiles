#!/bin/bash

# DEFINE VARIABLES
PROJECT_DIR="$HOME/.dotfiles"
TARGET_DIR="$HOME"                             # Target directory for symlinking dotfiles
ZSH_CONFIG_DIR="$PROJECT_DIR/zsh_config"       # Path to zsh configuration files (if applicable)
SRC_CONFIG_DIR="$PROJECT_DIR/config_files"     # Path to dotfiles directory
TARGET_CONFIG_DIR="$TARGET_DIR/.config"        # Path to the target dir to symlink the config files to
BACKUP_CONFIG_DIR="$TARGET_DIR/.config_backup" # Path to use for the backup of the `$TARGET_CONFIG_DIR`

# git information
GIT_NAME="Martin Cox"
GIT_EMAIL="martincox99@me.com"

# Function to backup the current `~/.config` directory if it exists
backup_configs() {
  # Check if it already exists
  if [ -e "$TARGET_CONFIG_DIR" ]; then
    # Create the backup directory
    mkdir -p ${BACKUP_CONFIG_DIR}

    # If it does exist, move it's contents to the new backup config directory we just created
    mv "$TARGET_CONFIG_DIR"/* "$BACKUP_CONFIG_DIR"
  else
    mkdir -p ${TARGET_CONFIG_DIR}
  fi
}

# Function to symlink the dotfiles to $HOME
symlink_dotfiles() {
  for config_item in "$SRC_CONFIG_DIR"/*; do
    ln -s "$config_item" "$TARGET_CONFIG_DIR/$(basename "$config_item")"
  done

  ln -s "$PROJECT_DIR/zsh/zshrc" "$TARGET_DIR/.zshrc"
}

# Function to assign the git name and email
git_setup() {
  # Ensure that git is setup with a name and email
  git config --global user.email "$GIT_EMAIL"
  git config --global user.name "$GIT_NAME"
}

# Function to install Homebrew
install_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    echo "Homebrew is already installed"
  else
    echo "Homebrew not installed yet, running installation now..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
}

# Function to initialize and update the oh-my-zsh submodule as well as any other submodules
initialize_submodules() {
  git submodule init
  git submodule update

  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  # Now install / initialize oh-my-zsh
  source "$TARGET_CONFIG_DIR/zsh/zshrc"
}

# Function to install `exa` via homebrew
install_exa() {

  if ! command -v exa >/dev/null 2>&1; then
    echo "Installing 'exa' via 'brew install exa'..."

    # Ensure we have brew installed first
    if command -v brew >/dev/null 2>&1; then
      brew install exa
      echo "Installed exa"
    fi
  fi
}

# Execute the installation steps
main() {
  # Change it to a hidden file so `.dotfiles` instead of `dotfiles`
  mv "$TARGET_DIR/dotfiles" "$PROJECT_DIR"

  # Change into that directory so the `git` commands will work properly
  cd "$PROJECT_DIR"

  backup_configs || {
    echo "Failed to create backup of '.config' directory"
    exit 1
  }
  symlink_dotfiles || {
    echo "Failed to symlink dotfiles"
    exit 1
  }
  git_setup || {
    echo "Failed to setup git with name and email"
    exit 1
  }
  install_homebrew || {
    echo "Failed to install Homebrew"
    exit 1
  }
  install_exa || {
    echo "Failed to install exa"
    exit 1
  }
  initialize_submodules || {
    echo "Failed to initialize or update git submodules"
    exit 1
  }
}

# Set error handling
set -e

# Invoke the main function
main "$@"
