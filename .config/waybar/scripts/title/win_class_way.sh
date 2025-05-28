#!/usr/bin/env bash

# Define the mapping
declare -A PKGS=(
    ["Code"]="VsCode"
    ["kitty"]="Kitty"
    ["org.telegram.desktop"]="Telegram"
    ["org.mozilla.firefox"]="Firefox"
    ["Org.chromium.Chromium"]="Chromium"
)

# Define the mapping between app names and symbols
declare -A SYMBOLS=(
    ["Code"]="󪥢"
    ["kitty"]="󪥌"
    ["org.telegram.desktop"]="󪥣"
    ["Org.chromium.Chromium"]="󪤕"
    ["org.mozilla.firefox"]="󪥲"
    ["Spotify"]="󪥵"
)

app_name=$(hyprctl activewindow | grep -oP 'class: \K[^\s]+')


# Check if app_name is null
if [ -z "$app_name" ]; then
    class="noicon" #not used
    symbol="󪥈"
    pkg="Hypr"
else
    
    # Check if the app_name is a valid key in the PKGS array
    if [[ ${PKGS["$app_name"]+abc} ]]; then
        pkg=${PKGS["$app_name"]}
    else
        pkg=$app_name
    fi
    
    # Check if app_name is null
    if [ -z "$app_name" ]; then
        class="noicon" #not used
        symbol="󪥈"
        pkg="Hypr"
    else
        # Retrieve the symbol from the mapping
        symbol=${SYMBOLS[$app_name]}
        
        # Check if symbol is null or empty
        if [ -z "$symbol" ]; then
            symbol="󪤉"
        else
            class=$pkg
        fi
        
        
        if [ -z "$pkg" ] && [ -z "$symbol" ]; then
            class="noicon" #not used
            symbol="󪥈"
            pkg="Hypr"
        fi
        
    fi
fi

result="{\"text\":\""$pkg"\",\"alt\":\""$symbol"\",\"class\":\""$class"\"}"
echo -e $result
