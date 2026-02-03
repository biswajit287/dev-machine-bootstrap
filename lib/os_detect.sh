#!/bin/bash

OS_TYPE=$(uname -s)
ARCH_TYPE=$(uname -m)

IS_MAC=false
IS_LINUX=false
IS_ARM=false

if [[ "$OS_TYPE" == "Darwin" ]]; then
  IS_MAC=true
  [[ "$ARCH_TYPE" == "arm64" ]] && IS_ARM=true
elif [[ "$OS_TYPE" == "Linux" ]]; then
  IS_LINUX=true
fi

# Export for sub-scripts
export IS_MAC IS_LINUX IS_ARM ARCH_TYPE
