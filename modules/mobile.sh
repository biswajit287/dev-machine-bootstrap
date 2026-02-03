#!/bin/bash

source ./modules/helpers/flutter.sh
source ./modules/helpers/android.sh

run_mobile_module() {
  log_info "--- Category: Mobile Development ---"

  # Install Android Studio
  if config_enabled "features.android_studio"; then
    if [[ "$IS_MAC" == true ]]; then
      if ! brew list --cask android-studio &> /dev/null; then
        log_info "Installing Android Studio..."
        install_pkg android-studio
      else
        log_success "Android Studio is already installed."
      fi
    elif [[ "$IS_LINUX" == true ]]; then
      if ! exists android-studio; then
        log_info "Installing Android Studio..."
        sudo snap install android-studio --classic
      else
        log_success "Android Studio is already installed."
      fi
    fi
  fi

  # Install Flutter
  if config_enabled "features.flutter"; then
    install_flutter
  fi

  # Install Android SDK Command Line Tools
  if config_enabled "features.android"; then
    install_android_sdk
  fi

  # Install Xcode Command Line Tools on Mac
  if [[ "$IS_MAC" == true ]]; then
    # Xcode Command Line Tools (Required for Brew)
    if ! xcode-select -p &> /dev/null; then
      log_info "Installing Xcode Command Line Tools..."
      # This triggers the non-interactive install
      touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
      local pkg
      pkg=$(softwareupdate -l | grep "\*.*Command Line" | tail -n 1 | awk -F"*" '{print $2}' | sed -e 's/^ *//' | tr -d '\n')
      softwareupdate -i "$pkg" --verbose
      rm /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
      log_success "Command Line Tools installed."
    else
      log_success "Xcode Command Line Tools already present."
    fi

    # Full Xcode IDE (Optional, via App Store)
    if config_enabled "mobile.apple.xcode_ide"; then
      if ! [ -d "/Applications/Xcode.app" ]; then
        log_info "Installing Full Xcode IDE (this will take a while)..."
        # 'mas' is the Mac App Store CLI
        if ! exists mas; then
          install_pkg "mas"
        fi
        # Xcode App Store ID is 497799835
        mas get 497799835
        mas install 497799835
      fi

      # Accept EULA (Requires sudo)
      log_info "Accepting Xcode EULA..."
      sudo xcodebuild -license accept
    fi

    # Install CocoaPods
    if ! exists pod; then
      log_info "Installing CocoaPods..."
      # Brew is preferred over 'gem install' to avoid sudo/ruby permission issues
      install_pkg "cocoapods"
    else
      log_success "CocoaPods is already installed."
    fi

    # Setup iOS Simulator Runtimes
    # This fixes the "Unable to get list of installed Simulator runtimes" error
    if xcode-select -p &> /dev/null; then
      log_info "Checking for iOS Simulator runtimes..."
      # This triggers the download of the latest stable iOS runtime
      # We use 'quiet' to keep the logs clean
      sudo xcodebuild -downloadPlatform iOS
    fi

    # Final Flutter-iOS Link
    if exists flutter; then
      log_info "Configuring Flutter for iOS..."
      sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
      sudo xcodebuild -runFirstLaunch
    fi
  fi
}
