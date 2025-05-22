#!/usr/bin/env bash

sudo pacman -S --noconfirm \
# must have
git \
neovim \
base-devel \
networkmanager \
linux-firmware \
lsof \
# bluetooth support
bluez \
bluez-utils \
# audio support
wireplumber \
pipewire-pulse \
pipewire \
# additional packages
playerctl \
brightnessctl \
slurp \
grim \
jq \
ttf-jetbrains-mono-nerd \
# windows manager and helpers
hyprland \
hyprlock \
hyprpaper \
# bar
waybar \
# application menu
rofi-wayland \
# flatpak
flatpak
