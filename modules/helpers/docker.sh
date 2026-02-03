#!/bin/bash

install_docker() {
  # Docker
  if config_enabled ".features.docker"; then
    if [[ "$IS_MAC" == true ]]; then
      brew install --cask docker
    else
      install_pkg docker.io
      sudo usermod -aG docker "$USER"
    fi
  fi
}
