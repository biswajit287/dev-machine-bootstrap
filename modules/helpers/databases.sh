#!/bin/bash

install_databases() {
  # PostgreSQL
  if config_enabled ".infrastructure.databases.postgresql"; then
    install_pkg "postgresql"
  fi

  # MySQL
  if config_enabled ".infrastructure.databases.mysql"; then
    # Note: On Mac, 'mysql' is the server, 'mysql-client' is just the CLI
    install_pkg "mysql-client"
  fi

  # Redis
  if config_enabled ".infrastructure.databases.redis"; then
    install_pkg "redis"
  fi
}
