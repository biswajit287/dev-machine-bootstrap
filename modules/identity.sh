#!/bin/bash

source ./modules/helpers/ssh.sh

run_identity_module() {
  log_info "--- Category: Identity & Security ---"

  # Configure Git identity
  if config_enabled "features.git_identity"; then
    local git_name
    git_name=$(read_conf ".security.git.name")
    local git_email
    git_email=$(read_conf ".security.git.email")
    local git_branch
    git_branch=$(read_conf ".security.git.default_branch")

    log_info "Configuring Git for $git_name..."

    git config --global user.name "$git_name"
    git config --global user.email "$git_email"
    git config --global init.defaultBranch "${git_branch:-main}"

    # Enable colored output for better readability
    git config --global color.ui auto

    log_success "Git identity updated."
  fi

  # Install SSH keys
  install_ssh_keys
}
