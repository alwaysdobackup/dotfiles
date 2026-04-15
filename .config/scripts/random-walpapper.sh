#!/usr/bin/env bash

set -e

# Config
IMG="/tmp/wallhaven_current.jpg"

# Fetch random 4K wallpaper metadata from Wallhaven API

JSON=$(curl -s "https://wallhaven.cc/api/v1/search?atleast=3840x2160&sorting=random")

# Extract image URL (first result)

URL=$(echo "$JSON" | jq -r '.data[0].path')

if [[ "$URL" == "null" || -z "$URL" ]]; then
echo "Failed to fetch wallpaper URL"
exit 1
fi

echo "Downloading: $URL"

# Download image

curl -L "$URL" -o "$IMG"

# Kill existing swaybg

pkill swaybg 2>/dev/null || true

# Set wallpaper

swaybg -i "$IMG" -m fill &

echo "Wallpaper set: $IMG"

