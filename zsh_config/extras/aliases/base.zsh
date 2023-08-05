alias c="clear"
alias cll="clear;list_dir_contents"
alias ll="list_dir_contents"

# Change directory and list contents
# Usage: cd [directory]
# If no directory is provided, the default is $HOME
cdl() {
  local target_dir="${1:-$HOME}"

  if builtin cd "$target_dir"; then
    list_dir_contents
  fi
}

# List the contents of the current directory
# Check if exa is installed, and use it if available,
# otherwise fallback to using ls
list_dir_contents() {
  # If exa is installed, use it
  if command -v exa >/dev/null 2>&1; then
    # List contents using exa
    exa -lha --color=always --group-directories-first --no-file-size --no-time
  else
    # List contents using ls
    ls -la1 --color=always --group-directories-first
  fi
}
