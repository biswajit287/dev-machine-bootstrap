#!/bin/bash
set -euo pipefail

# Load OS detection if available to keep it modular
source ./lib/os_detect.sh 2> /dev/null || IS_MAC=false

# Dependency Check & Installation
install_dependency() {
  local tool=$1
  if ! command -v "$tool" &> /dev/null; then
    echo "⚠️ $tool not found. Attempting to install..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
      brew install "$tool"
    else
      # Assumes Ubuntu/Debian for the Linux test environment
      sudo apt-get update && sudo apt-get install -y "$tool"
    fi
  fi
}

install_dependency "shfmt"
install_dependency "shellcheck"

# Processing Files
TARGET_DIR="${1:-.}"
echo "🚀 Starting Bash Quality Check in $TARGET_DIR..."

find "$TARGET_DIR" -type f -name "*.sh" -not -path '*/.*' | while read -r file; do
  echo "Processing: $file"

  # Format
  shfmt -w -i 2 -ci -sr -bn "$file"

  # Lint (using -x to follow source links in your modular structure)
  shellcheck -x "$file" || echo "❌ Issues in $file"
done

echo "✅ Done!"
