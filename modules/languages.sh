#!/bin/bash

source ./modules/helpers/java.sh

run_languages_module() {
  log_info "--- Category: Languages & Runtimes ---"

  # Node.js (via NVM)
  if config_enabled "features.node"; then
    local node_ver
    node_ver=$(read_conf ".languages.node.version")
    log_info "Setting up Node.js ($node_ver) via NVM..."

    if [[ ! -d "$HOME/.nvm" ]]; then
      curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    fi

    # Load NVM for current session
    export NVM_DIR="$HOME/.nvm"
    # shellcheck disable=SC1091
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    nvm install "$node_ver"
    nvm use "$node_ver"
    # shellcheck disable=SC2016
    ensure_line 'export NVM_DIR="$HOME/.nvm"' "$HOME/.zshrc"
    # shellcheck disable=SC2016
    ensure_line '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' "$HOME/.zshrc"
  fi

  # PHP & Composer
  if config_enabled "features.php"; then
    local php_ver
    php_ver=$(read_conf ".languages.php.version")
    log_info "Installing PHP $php_ver..."

    if [[ "$IS_MAC" == true ]]; then
      install_pkg "php@$php_ver"
      brew link --overwrite "php@$php_ver"
    else
      # Linux (Ubuntu/Debian) PPA approach
      sudo apt update
      sudo apt install -y software-properties-common
      sudo add-apt-repository ppa:ondrej/php -y
      sudo apt update
      install_pkg "php$php_ver"
      install_pkg "php$php_ver-cli" "php$php_ver-mbstring" "php$php_ver-xml" "php$php_ver-curl"
    fi

    if config_enabled ".languages.php.composer"; then
      if ! exists composer; then
        log_info "Installing Composer..."
        curl -sS https://getcomposer.org/installer | php
        sudo mv composer.phar /usr/local/bin/composer
      fi
    fi
  fi

  # Java (via SDKMAN for Linux, Brew for Mac)
  if config_enabled "features.java"; then
    install_java
  fi

  # Python
  if config_enabled "features.python"; then
    local py_ver
    py_ver=$(read_conf ".languages.python.version")
    log_info "Installing Python $py_ver..."

    if [[ "$IS_MAC" == true ]]; then
      install_pkg "python@$py_ver"
    else
      sudo apt update
      install_pkg "python3"
      install_pkg "python3-pip"
    fi
  fi
}
