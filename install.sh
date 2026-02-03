#!/bin/bash
set -e

# Load core logic
source ./lib/os_detect.sh
source ./lib/utils.sh
source ./lib/pkg_manager.sh

# Install homebrew if on Mac and not installed
if [[ "$IS_MAC" == true ]]; then
  if ! exists brew; then
    log_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Add brew to current path for immediate use
    eval "$(/opt/homebrew/bin/brew shellenv)" 2> /dev/null || eval "$(/usr/local/bin/brew shellenv)"
  else
    log_success "Homebrew is already installed."
  fi
fi

# Ensure yq is available for parsing
if ! command -v yq > /dev/null 2>&1; then
  install_pkg yq
fi

log_info "Starting Setup for $OS_TYPE ($ARCH_TYPE)"

# Core Layer
source ./modules/core.sh && run_core_module

# Terminal & Shell Layer
source ./modules/terminal.sh && run_terminal_module

# Editors Layer
source ./modules/editors.sh && run_editors_module

# Languages & Runtimes Layer
source ./modules/languages.sh && run_languages_module

# Apps Layer
source ./modules/apps.sh && run_apps_module

# Infrastructure & Cloud Layer
source ./modules/infra.sh && run_infra_module

# Mobile Development Layer
source ./modules/mobile.sh && run_mobile_module

log_success "Setup Complete! Restart your terminal or run 'source ~/.zshrc'"
