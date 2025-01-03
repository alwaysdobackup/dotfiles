#!/usr/bin/env bash

# INSTALL REQUIREMENTS
sudo pacman -S --needed --noconfirm base-devel git

# CHANGE WORK DIR
if test -d ~/Downloads; then
	cd ~/Downloads
else
	mkdir ~/Downloads
	cd ~/Downloads
fi

# CLONE YAY
git clone https://aur.archlinux.org/yay-bin.git

# CHANGE WORK DIR
cd yay-bin

# INSTALL YAY
makepkg -si

# CHECK VERSION
yay --version

# CLEAN
if [ "$?" -eq 0 ]; then
	cd ~/Downloads
	rm -rf yay-bin
fi
