#!/bin/bash

# Detect Package Manager
if command -v brew > /dev/null 2>&1; then
  PKG_MGR="brew"
  INSTALL_CMD="brew install"
  CASK_CMD="brew install --cask"
#   UPDATE_CMD="brew update"
elif command -v apt-get > /dev/null 2>&1; then
  PKG_MGR="apt"
  INSTALL_CMD="sudo apt-get install -y"
#   UPDATE_CMD="sudo apt-get update"
elif command -v dnf > /dev/null 2>&1; then
  PKG_MGR="dnf"
  INSTALL_CMD="sudo dnf install -y"
#   UPDATE_CMD="sudo dnf check-update"
else
  log_error "No supported package manager found (brew, apt, dnf)."
  exit 1
fi

install_pkg() {
  local pkg=$1

  if [[ "$PKG_MGR" == "brew" ]]; then
    # Check if the package is already known to be a cask to install using cask
    if brew info --cask "$pkg" > /dev/null 2>&1; then
      log_info "Installing GUI App: $pkg via brew cask..."
      $CASK_CMD "$pkg"
      return
    fi
  fi

  log_info "Installing CLI Tool: $pkg via $PKG_MGR..."
  $INSTALL_CMD "$pkg"
}
