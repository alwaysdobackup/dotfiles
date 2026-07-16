#!/usr/bin/env bash

set -euo pipefail

declare -a packages=(
  "org.telegram.desktop"
  "com.spotify.Client"
#  "com.visualstudio.code"  # maybe not required
  "md.obsidian.Obsidian"
  "app.zen_browser.zen"
  "org.videolan.VLC"
  "us.zoom.Zoom"
)

flatpak install flathub "${packages[@]}" -y

