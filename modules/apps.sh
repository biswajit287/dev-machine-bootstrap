#!/bin/bash

run_apps_module() {
  log_info "--- Category: GUI Applications ---"

  # Process the generic 'apps' list
  local generic_apps
  generic_apps=$(read_conf '.apps[]' config.yaml)

  for app in $generic_apps; do
    # We pass "true" as the second argument to trigger the --cask flag on Mac
    if [[ "$IS_MAC" == true ]]; then
      # Check if already installed to save time
      if ! brew list --cask "$app" &> /dev/null; then
        install_pkg "$app"
      else
        log_success "$app is already installed."
      fi
    elif [[ "$IS_LINUX" == true ]]; then
      install_linux_app "$app"
    fi
  done
}

# --- Linux Install Helpers ---
install_linux_app() {
  local app=$1
  log_info "Attempting to install $app via Snap..."

  # Check if snap is installed first
  if ! exists snap; then
    sudo apt update && sudo apt install snapd -y
  fi

  case "$app" in
    "tableplus")
      # TablePlus has an official .deb repo, not a snap
      wget -qO - https://deb.tableplus.com/apt.tableplus.com.gpg.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/tableplus-archive.gpg > /dev/null
      sudo add-apt-repository "deb [arch=amd64] https://apt.tableplus.com/debian/22 universal main" -y
      sudo apt update && sudo apt install tableplus -y
      ;;
    *)
      # Slack, Discord, and Postman are all on Snap
      sudo snap install "$app"
      ;;
  esac
}
