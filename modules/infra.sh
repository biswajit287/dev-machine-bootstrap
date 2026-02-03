#!/bin/bash

source ./modules/helpers/databases.sh

run_infra_module() {
  log_info "--- Category: Infrastructure & Cloud ---"

  # Docker
  if config_enabled "features.docker"; then
    if [[ "$IS_MAC" == true ]]; then
      # On Mac, we usually want the Desktop GUI
      if config_enabled ".infrastructure.docker.install_desktop"; then
        install_pkg "docker"
      fi
    else
      # Linux: Install Docker Engine natively
      if ! exists docker; then
        log_info "Installing Docker Engine for Linux..."
        sudo apt-get update
        sudo apt-get install -y ca-certificates curl gnupg
        # Add Docker's official GPG key and repo
        sudo install -m 0755 -d /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        sudo chmod a+r /etc/apt/keyrings/docker.gpg
        # shellcheck disable=SC1091
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt-get update
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        sudo usermod -aG docker "$USER"
      fi
    fi
  fi

  # AWS CLI
  if config_enabled "features.aws_cli"; then
    if ! exists aws; then
      if [[ "$IS_MAC" == true ]]; then
        install_pkg "awscli"
      else
        log_info "Installing AWS CLI for Linux..."
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
        unzip -q awscliv2.zip && sudo ./aws/install && rm -rf aws awscliv2.zip
      fi
    fi
    # Set default region from config
    local region
    region=$(read_conf ".infrastructure.aws.region")
    aws configure set region "$region"
  fi

  # Databases (Clients/Services)
  if config_enabled "features.databases"; then
    log_info "Processing Database Clients..."

    install_databases
  fi
}
