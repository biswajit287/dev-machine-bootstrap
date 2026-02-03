#!/bin/bash

install_vscode_extensions() {
  # Check if vscode extenstions is enabled
  if ! config_enabled "editors.vscode.install_extensions"; then
    return
  fi

  # Check for the 'code' binary
  if ! exists code; then
    log_warn "VS Code CLI ('code') not found. Skipping extensions."
    return
  fi

  log_info "Installing VS Code extensions..."

  # Use yq to get the extensions as a flat list
  # The '.[]' syntax iterates through the array under editors.vscode.extensions
  local extensions
  extensions=$(read_conf '.editors.vscode.extensions[]' config.yaml)

  # Check if the list is empty
  if [[ -z "$extensions" ]]; then
    log_info "No extensions found in config."
    return
  fi

  for ext in $extensions; do
    log_info "Installing extension: $ext"
    if code --list-extensions | grep -qi "^$ext$"; then
      log_info "  ✓ $ext already installed."
    else
      code --install-extension "$ext" --force
    fi
  done

  log_success "VS Code extensions synced."
}

install_vscode() {
  if ! config_enabled ".features.vscode"; then return; fi

  # Check if we should install the app itself
  if config_enabled ".features.vscode.install_app"; then
    if [[ "$IS_MAC" == true ]]; then
      install_pkg visual-studio-code
    else
      install_pkg code # Assumes VS Code is in your Linux repo
    fi
  fi
}
