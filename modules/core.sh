#!/bin/bash

run_core_module() {
  log_info "--- Category: Core System ---"

  # Install vim
  if config_enabled "features.vim"; then
    if [[ "$IS_MAC" == true ]]; then
      brew install vim
    elif [[ "$IS_LINUX" == true ]]; then
      sudo apt-get install -y vim
    fi
    log_success "Installed Vim."
  fi
}
