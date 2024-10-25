#!/usr/bin/env sh

CURRENT_LAYOUT=$(setxkbmap -query | awk -F : 'NR==3{print $2}' | sed 's/ //g')

if [ $CURRENT_LAYOUT == "us" ]; then
    setxkbmap "ua,us"
else
    setxkbmap "us"
fi

