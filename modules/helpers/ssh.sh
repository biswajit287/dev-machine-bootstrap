#!/bin/bash

install_ssh_keys() {
  log_info "--- Category: Security & Identity (SSH) ---"

  local key_type
  key_type=$(read_conf '.security.ssh.type' config.yaml)
  local email
  email=$(read_conf '.security.git.email' config.yaml)
  local key_file="$HOME/.ssh/id_$key_type"

  # 1. Check if key already exists (Idempotency)
  if [[ -f "$key_file" ]]; then
    log_success "SSH key already exists at $key_file. Skipping generation."
  else
    # 2. Check if generation is enabled in config
    if [[ $(read_conf '.security.ssh.generate_new' config.yaml) == "true" ]]; then
      log_info "Generating new $key_type SSH key for $email..."

      # Ensure the .ssh directory exists with correct permissions
      mkdir -p "$HOME"/.ssh && chmod 700 "$HOME"/.ssh

      # Generate the key using the 'run' wrapper for Dry Run support
      # -N '' specifies an empty passphrase (adjust if you prefer manual input)
      ssh-keygen -t "$key_type" -C "$email" -f "$key_file" -N ''

      log_success "SSH key generated successfully."
    else
      log_warn "SSH key missing, but 'generate_new' is set to false in config.yaml."
    fi
  fi

  # 3. Start the SSH agent and add the key
  if [[ -f "$key_file" ]]; then
    log_info "Adding SSH key to agent..."
    eval "$(ssh-agent -s)"

    if [[ "$IS_MAC" == true ]]; then
      # macOS specific: Add to keychain
      ssh-add --apple-use-keychain "$key_file"
    else
      ssh-add "$key_file"
    fi
  fi
}
