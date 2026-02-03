#!/bin/bash

install_java() {
  if config_enabled ".features.java"; then
    local version
    version=$(read_conf ".languages.java.version")

    if [[ "$IS_MAC" == true ]]; then
      # For Mac, we use Homebrew via our wrapper
      install_pkg "openjdk@$version"
      sudo ln -sfn "$(brew --prefix openjdk@"$version")/libexec/openjdk.jdk" /Library/Java/JavaVirtualMachines/openjdk.jdk
    else
      # For Linux/Intel, SDKMAN is the most modular way
      if ! exists sdk; then
        log_info "Installing SDKMAN..."
        curl -s "https://get.sdkman.io" | bash
        # shellcheck disable=SC1091
        source "$HOME/.sdkman/bin/sdkman-init.sh"
      fi
      sdk install java "${version}.0.1-tem"
    fi

    log_success "Java $version installed."
  fi
}
