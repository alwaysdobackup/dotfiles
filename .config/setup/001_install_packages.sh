#!/usr/bin/env bash

set -euo pipefail

# Core / CLI tools
declare -a core_packages=(
  "alacritty"
  "git"
  "neovim"
  "tmux"
  "vifm"
  "ripgrep"
  "fd"
  "jq"
  "bc"
  "lsof"
  "unzip"
  "tree-sitter-cli"
)

# Audio
declare -a audio_packages=(
  "pipewire"
  "wireplumber"
  "pipewire-pulse"
  "pulsemixer"
  "playerctl"
)

# Bluetooth
declare -a bluetooth_packages=(
  "bluez"
  "bluez-utils"
  "bluetui"
)

# Sway / Wayland desktop
declare -a sway_packages=(
  "sway"
  "swaylock"
  "swayidle"
  "swaybg"
  "swaync"
  "swayimg"
  "waybar"
  "rofi"
)

# Screenshots / clipboard
declare -a screen_clipboard_packages=(
  "slurp"
  "grim"
  "wl-clipboard"
  "cliphist"
)

# Misc utilities
declare -a misc_packages=(
  "flatpak"
  "libnotify"
  "calcurse"
  "ttf-fira-code"
  "ttf-firacode-nerd"
)

# Combine all groups into one array
declare -a packages=(
  "${core_packages[@]}"
  "${audio_packages[@]}"
  "${bluetooth_packages[@]}"
  "${sway_packages[@]}"
  "${screen_clipboard_packages[@]}"
  "${misc_packages[@]}"
)

# Install everything in a single transaction
sudo pacman -S --needed --noconfirm "${packages[@]}"
