#!/usr/bin/env bash
set -Eeuo pipefail
shopt -s extglob

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DEST_DIR="$HOME/.config/quickshell"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"

echo "$SCRIPT_DIR"

if [[ -d "$DEST_DIR" ]]; then
  mv "$DEST_DIR" "${DEST_DIR}.bak.${TIMESTAMP}"
  echo "backup created!"
  mkdir -p "$DEST_DIR"
else
  echo "destination not found! creating"
  mkdir -p "$DEST_DIR"
  echo "destination created!"
fi

cp -a "$SCRIPT_DIR"/!(install.sh) "$DEST_DIR"
echo "shell installed!"
echo "installation complete!"
