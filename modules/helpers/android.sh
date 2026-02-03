#!/bin/bash

install_android_sdk() {
  if ! config_enabled ".features.android"; then return; fi

  log_info "Starting Headless Android SDK Installation..."

  # Get path from config and expand variables
  local raw_path
  raw_path=$(read_conf ".mobile.android.path")
  # Expand ~ and $USER
  local sdk_path
  sdk_path=$(expand_path "$raw_path")

  log_info "Targeting Android SDK path: $sdk_path"
  mkdir -p "$sdk_path/cmdline-tools"

  # Download Command Line Tools if missing
  local CMDLINE_TOOLS_DIR="$sdk_path/cmdline-tools"
  if [[ ! -d "$CMDLINE_TOOLS_DIR/latest" ]]; then
    log_info "Downloading Android Command Line Tools..."
    if [[ "$IS_MAC" == true ]]; then
      URL="https://dl.google.com/android/repository/commandlinetools-mac-14742923_latest.zip"
    else
      URL="https://dl.google.com/android/repository/commandlinetools-linux-14742923_latest.zip"
    fi

    curl -o /tmp/cmdline-tools.zip "$URL"
    unzip -q /tmp/cmdline-tools.zip -d "$CMDLINE_TOOLS_DIR"
    mv "$CMDLINE_TOOLS_DIR/cmdline-tools" "$CMDLINE_TOOLS_DIR/latest"
    rm /tmp/cmdline-tools.zip
  fi

  # Set environment for current session to run sdkmanager
  export ANDROID_HOME="$sdk_path"
  export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools"

  # Accept licenses and install components
  log_info "Accepting licenses..."
  yes | sdkmanager --licenses > /dev/null

  for component in $(yq -r '.mobile.android.components[]' config.yaml); do
    log_info "Installing $component..."
    sdkmanager "$component"
  done

  # Persist to .zshrc
  ensure_line "export ANDROID_HOME=$sdk_path" "$HOME/.zshrc"
  # shellcheck disable=SC2016
  ensure_line 'export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools' "$HOME/.zshrc"

  log_success "Android SDK setup complete at $sdk_path"
}
