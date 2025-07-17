#!/bin/bash

### FOR UBUNTU

# --- Configuration ---
RESOLUTION="3840x2160"                         # Hardcoded monitor resolution
TEMP_DIR="/var/tmp"                        # Temporary folder for the image
IMAGE_PATH="$TEMP_DIR/wallhaven.jpg"           # Output image path
WALLHAVEN_API="https://wallhaven.cc/api/v1/search"
USER_AGENT="Mozilla/5.0"

# --- Get random image metadata ---
echo "Fetching random wallpaper metadata from Wallhaven..."

RESPONSE=$(curl -s -A "$USER_AGENT" "$WALLHAVEN_API?atleast=${RESOLUTION}&sorting=random&categories=111&purity=100")

# Extract the first image ID from the JSON response
IMAGE_ID=$(echo "$RESPONSE" | grep -oP '"id":"\K[^"]+' | head -n1)

if [ -z "$IMAGE_ID" ]; then
    echo "Failed to fetch image ID from Wallhaven."
    exit 1
fi

# Construct full image URL
IMAGE_URL="https://w.wallhaven.cc/full/${IMAGE_ID:0:2}/wallhaven-${IMAGE_ID}.jpg"

echo "Downloading wallpaper from: $IMAGE_URL"

# --- Download the image ---
curl -s -A "$USER_AGENT" -o "$IMAGE_PATH" "$IMAGE_URL"

if [ ! -f "$IMAGE_PATH" ]; then
    echo "Failed to download image."
    exit 1
fi

# --- Set as wallpaper in Ubuntu (GNOME) ---
echo "Setting wallpaper..."

gsettings set org.gnome.desktop.background picture-uri "file://$IMAGE_PATH"
gsettings set org.gnome.desktop.background picture-uri-dark "file://$IMAGE_PATH"

echo "Wallpaper set successfully."

# Optional: Clean up temp dir on reboot or with cron if you like.

