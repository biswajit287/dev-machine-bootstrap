#!/bin/bash

# --- Config Helpers ---

# Define colors for better logging
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Returns true (0) or false (1) based on YAML toggle
# Usage: if config_enabled ".features.java"; then ...
config_enabled() {
  local query=$1
  # Ensure the query starts with a dot if it doesn't already
  [[ "$query" != .* ]] && query=".$query"

  local value
  value=$(yq -r "$query" config.yaml)
  log_info "Checking config for $query: $value"

  if [[ "$value" == "true" ]]; then
    return 0
  else
    return 1
  fi
}

# General string reader for YAML
# Usage: version=$(read_conf ".languages.java.version")
read_conf() {
  yq -r "$1" config.yaml
}

# Handle path expansion (~/$USER to /Users/name)
expand_path() {
  eval echo "$1"
}

# Checks if a command exists in the current PATH
exists() {
  command -v "$1" > /dev/null 2>&1
}

# --- File Manipulation Helpers ---

# Ensures a specific line exists in a file (like .zshrc)
# Usage: ensure_line 'export PATH="$PATH:/my/bin"' "$HOME/.zshrc"
ensure_line() {
  local line=$1
  local file=$2

  # Create file if it doesn't exist
  if [[ ! -f "$file" ]]; then
    touch "$file"
  fi

  # Check if line already exists (escaped for grep)
  if ! grep -Fxq "$line" "$file"; then
    echo -e "\n$line" >> "$file"
    log_success "Added line to $file: $line"
  else
    log_info "Line already exists in $file. Skipping."
  fi
}

# Usage: replace_or_add "SEARCH_KEY" "NEW_FULL_LINE" "FILE_PATH"
# Example: replace_or_add "ZSH_THEME=" "ZSH_THEME=\"powerlevel10k/powerlevel10k\"" "$HOME/.zshrc"
replace_or_add() {
  local key=$1
  local new_line=$2
  local file=$3

  if grep -q "^$key" "$file"; then
    # Use a temporary file to stay cross-platform (avoiding Mac vs Linux sed issues)
    grep -v "^$key" "$file" > "${file}.tmp"
    echo "$new_line" >> "${file}.tmp"
    mv "${file}.tmp" "$file"
  else
    echo "$new_line" >> "$file"
  fi
}
