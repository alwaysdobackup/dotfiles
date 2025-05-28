#!/usr/bin/env bash

# create folder structure
find .. -not -path "../setup" -type d -exec sh -c 'mkdir -p "$HOME/.config/${1#../}"' _ {} \;
# copy config files
find .. -type f -not -name "README.md" -not -path "../setup/*" -exec sh -c 'cp "$1" "/$HOME/.config/${1#../}"' _ {} \;

