#!/bin/bash

install_flutter() {
  if ! config_enabled ".features.flutter"; then return; fi

  # local raw_flutter_path=$(read_conf ".mobile.flutter.path")
  local flutter_path
  # shellcheck disable=SC2046
  flutter_path=$(expand_path $(read_conf ".mobile.flutter.path"))
  local flutter_version
  flutter_version=$(read_conf ".mobile.flutter.version")

  if [[ ! -d "$flutter_path" ]]; then
    log_info "Cloning Flutter ($flutter_version) to $flutter_path..."
    git clone https://github.com/flutter/flutter.git -b "$flutter_version" "$flutter_path"
  fi

  ensure_line "export PATH=\$PATH:$flutter_path/bin" "$HOME/.zshrc"

  # Run internal flutter setup
  export PATH="$PATH:$flutter_path/bin"
  flutter config --no-analytics
  log_info "Flutter installation complete. Run 'flutter doctor' after restarting terminal."
}
