#!/bin/bash

source ./modules/helpers/zsh.sh

run_terminal_module() {
  log_info "--- Category: Terminal & Shell ---"

  # Install iTerm2 for macOS if enabled
  if config_enabled "features.iterm2" && [[ "$IS_MAC" == true ]]; then
    if ! brew list --cask iterm2 &> /dev/null; then
      log_info "Installing iTerm2..."
      install_pkg iterm2
    else
      log_success "iTerm2 is already installed."
    fi
  fi

  # Install Zsh and Oh My Zsh if enabled
  if config_enabled "features.zsh"; then
    log_info "Setting up Zsh and Oh My Zsh..."
    if ! exists zsh; then
      install_pkg zsh
    fi

    # Install Oh My Zsh
    install_oh_my_zsh

    # Install Zsh theme
    install_zsh_theme

    # Install Zsh plugins
    install_zsh_plugins

    # Install custom aliases
    install_aliases
  fi
}
