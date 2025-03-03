#!/usr/bin/env bash

for file in $(find . -type f -name "*.sh" -not -name "init.sh" -print | sort); do
    # Execute the file
    bash "$file"
done
