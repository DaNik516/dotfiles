#!/usr/bin/env bash

# Define the output file
OUTPUT_FILE="$HOME/Downloads/nixos_install_report.txt"

(
  echo "=== NixOS Dev Environment Report (Safe Mode) ==="
  echo "Date: $(date)"
  echo "User: $USER"
  echo "------------------------------------"

  check_tool() {
    tool=$1
    echo ""
    echo "Checking: $tool"
    if command -v "$tool" &> /dev/null; then
      echo "  Path:    $(which "$tool")"
      
      # SAFE VERSION CHECK:
      # 1. Use 'timeout 2s' to kill the process if it hangs (like jdtls/ghc)
      # 2. Try --version, then -v, then -version
      version_info=$(timeout 2s "$tool" --version 2>&1 | head -n 1)
      
      if [ -z "$version_info" ]; then
         version_info=$(timeout 2s "$tool" -v 2>&1 | head -n 1)
      fi

      if [ -z "$version_info" ]; then
         echo "  Version: [Unable to auto-detect or Timed Out]"
      else
         echo "  Version: $version_info"
      fi
    else
      echo "  [MISSING] $tool is not in PATH"
    fi
  }

  echo ">>> C / C++"
  check_tool clang
  check_tool gcc

  echo ">>> GO"
  check_tool go

  echo ">>> HASKELL"
  check_tool ghc
  check_tool cabal

  echo ">>> JAVA"
  check_tool java
  # We know jdtls hangs on version check, so we just check existence manually
  if command -v jdtls &> /dev/null; then
      echo "Checking: jdtls"
      echo "  Path:    $(which jdtls)"
      echo "  Version: (Skipped check to prevent hang)"
  else
      echo "Checking: jdtls"
      echo "  [MISSING] jdtls"
  fi
  
  echo ""
  echo "Checking JAVA_HOME:"
  if [ -n "$JAVA_HOME" ]; then
    echo "  Path: $JAVA_HOME"
  else
    echo "  [WARNING] \$JAVA_HOME is NOT set."
  fi

  echo ">>> NIX"
  check_tool nix

  echo ">>> PYTHON"
  check_tool python3
  check_tool python

  echo ">>> RUST"
  check_tool rustc
  check_tool cargo

  echo ">>> SHELL"
  check_tool fish

  echo ">>> TYPST"
  check_tool typst

  echo "------------------------------------"
  echo "End of Report"
) > "$OUTPUT_FILE" 2>&1

echo "Done! Report saved to $OUTPUT_FILE"
