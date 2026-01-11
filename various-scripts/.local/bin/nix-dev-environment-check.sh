#!/usr/bin/env bash

# Define the output file
OUTPUT_FILE="$HOME/Downloads/nixos_install_report.txt"

(
  echo "=== NixOS Dev Environment Report ==="
  echo "Date: $(date)"
  echo "User: $USER"
  echo "------------------------------------"

  check_tool() {
    tool=$1
    echo ""
    echo "Checking: $tool"
    if command -v "$tool" &> /dev/null; then
      echo "  Path:    $(which "$tool")"
      # Try common version flags. redirect stderr to stdout to catch version info that prints to stderr
      echo -n "  Version: "
      "$tool" --version 2>&1 | head -n 1 || "$tool" -v 2>&1 | head -n 1 || echo "Version flag not found"
    else
      echo "  [MISSING] $tool is not in PATH"
    fi
  }

  echo ">>> C / C++"
  check_tool clang
  check_tool cmake
  check_tool gcc

  echo ">>> GO"
  check_tool go

  echo ">>> HASKELL"
  check_tool ghc
  check_tool cabal

  echo ">>> JAVA"
  check_tool java
  check_tool jdtls
  echo ""
  echo "Checking JAVA_HOME:"
  if [ -n "$JAVA_HOME" ]; then
    echo "  \$JAVA_HOME is set to: $JAVA_HOME"
  else
    echo "  [WARNING] \$JAVA_HOME is NOT set."
  fi

  echo ">>> JUPYTER"
  check_tool jupyter

  echo ">>> LATEX"
  check_tool pdflatex
  check_tool latexmk

  echo ">>> NIX"
  check_tool nix

  echo ">>> NODE / JS"
  check_tool node
  check_tool npm

  echo ">>> PHP"
  check_tool php

  echo ">>> PYTHON"
  check_tool python3
  check_tool python

  echo ">>> R"
  check_tool R

  echo ">>> RUST"
  check_tool rustc
  check_tool cargo
  check_tool rust-analyzer

  echo ">>> SHELL"
  check_tool fish
  check_tool shellcheck
  check_tool shfmt

  echo ">>> SWIFT"
  check_tool swift

  echo ">>> TYPST"
  check_tool typst

  echo "------------------------------------"
  echo "End of Report"
) > "$OUTPUT_FILE" 2>&1

echo "Done! The report is saved at: $OUTPUT_FILE"
