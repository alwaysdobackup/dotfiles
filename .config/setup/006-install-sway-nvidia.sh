#!/usr/bin/env bash

set -e

REPO_URL="https://github.com/crispyricepc/sway-nvidia"
TMP_DIR="/tmp/sway-nvidia-install"

echo "[+] Installing sway-nvidia manually..."

# --- Check dependencies ---
echo "[+] Checking dependencies..."
if ! command -v sway >/dev/null 2>&1; then
    echo "[!] sway is not installed. Please install it first."
    exit 1
fi

if ! command -v git >/dev/null 2>&1; then
    echo "[+] Installing git..."
    sudo pacman -S --needed --noconfirm git || sudo apt install -y git || sudo dnf install -y git
fi

# --- Clone repo ---
echo "[+] Cloning repository..."
rm -rf "$TMP_DIR"
git clone "$REPO_URL" "$TMP_DIR"

cd "$TMP_DIR"

# --- Install files ---
echo "[+] Installing files..."

sudo install -Dm755 sway-nvidia.sh /usr/local/bin/sway-nvidia
sudo install -Dm644 sway-nvidia.desktop /usr/share/wayland-sessions/sway-nvidia.desktop
sudo install -Dm644 wlroots-env-nvidia.sh /usr/local/share/wlroots-nvidia/wlroots-env-nvidia.sh

# --- Cleanup ---
cd ~
rm -rf "$TMP_DIR"

echo "[✓] Installation complete!"

echo ""
echo "Usage:"
echo "  - From TTY: exec sway-nvidia"
echo "  - From DM: select 'Sway (NVIDIA)' session"
