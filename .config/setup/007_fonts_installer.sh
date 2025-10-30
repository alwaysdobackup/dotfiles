#!/usr/bin/env bash
# =========================================================
# Universal GitHub Font Installer
# =========================================================
# Downloads latest releases of multiple fonts from GitHub,
# extracts font files, installs them locally, and refreshes
# the font cache.
# Works on Arch, Debian/Ubuntu, and similar Linux systems.
# =========================================================

set -euo pipefail
IFS=$'\n\t'
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

# --- Configuration ---
FONT_DIR="$HOME/.local/share/fonts"
API_BASE="https://api.github.com/repos"

# Add any GitHub repos here in "owner/repo" format
FONTS=(
  "FortAwesome/Font-Awesome"
  "tonsky/FiraCode"
)

# --- Helper functions ---
die() { echo "❌ Error: $*" >&2; exit 1; }

install_deps() {
  echo "→ Checking dependencies..."
  local deps=(curl jq unzip fc-cache)
  for cmd in "${deps[@]}"; do
    if ! command -v "$cmd" &>/dev/null; then
      echo "Installing missing dependency: $cmd"
      if command -v pacman &>/dev/null; then
        sudo pacman -S --noconfirm "$cmd"
      elif command -v apt &>/dev/null; then
        sudo apt update && sudo apt install -y "$cmd"
      else
        die "Unsupported package manager. Please install $cmd manually."
      fi
    fi
  done
}

install_font_from_repo() {
  local repo="$1"
  local name
  name="$(basename "$repo")"
  local install_path="$FONT_DIR/${name,,}"
  local api_url="$API_BASE/$repo/releases/latest"

  echo "=============================================="
  echo "→ Installing: $repo"
  echo "=============================================="

  # Fetch release info
  echo "→ Fetching latest release..."
  local release_json
  release_json=$(curl -s "$api_url") || die "Failed to fetch release info."
  local tag
  tag=$(echo "$release_json" | jq -r '.tag_name')

  # Find ZIP URL (most repos provide .zip assets)
  local zip_url
  zip_url=$(echo "$release_json" | jq -r '.assets[]?.browser_download_url' | grep -Ei '\.zip$' | head -n 1)
  [[ -z "$zip_url" ]] && { echo "⚠️ No ZIP file found for $repo"; return; }

  echo "→ Found release: $tag"
  echo "→ Downloading: $zip_url"

  # Download ZIP
  local zip_path="$TMP_DIR/$name.zip"
  curl -L -o "$zip_path" "$zip_url" || die "Download failed."

  # Test ZIP integrity
  unzip -tq "$zip_path" &>/dev/null || die "Corrupted ZIP for $repo."

  # Extract and copy fonts
  echo "→ Extracting fonts..."
  unzip -qq "$zip_path" -d "$TMP_DIR/$name"
  mkdir -p "$install_path"

  find "$TMP_DIR/$name" -type f \( -iname "*.otf" -o -iname "*.ttf" \) \
    -exec install -Dm644 {} "$install_path/$(basename "{}")" \;

  echo "✅ Installed $name ($tag) → $install_path"
}

# --- Main script ---
echo "=============================================="
echo "   Universal Font Installer (GitHub edition)"
echo "=============================================="

install_deps

for repo in "${FONTS[@]}"; do
  install_font_from_repo "$repo"
done

echo "→ Refreshing font cache..."
fc-cache -fv "$FONT_DIR" >/dev/null

echo "=============================================="
echo "✅ All fonts installed successfully!"
echo "   Location: $FONT_DIR"
echo "=============================================="

