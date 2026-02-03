#!/bin/bash

source ./modules/helpers/vscode.sh

run_editors_module() {
  # VS Code app
  if config_enabled ".features.vscode"; then
    install_vscode
  fi

  # VS Code extensions
  install_vscode_extensions
}
