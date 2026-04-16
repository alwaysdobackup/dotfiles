#!/usr/bin/env bash

# Disable Intel Sound Card power_save
echo "options snd_hda_intel power_save=0" | sudo tee /etc/modprobe.d/snd-hda-intel.conf

# Set fn keys work mode
# 2 = fkeysfirst: Function keys are used as first key. Pressing 'F8' key will behave like a F8. Pressing 'fn'+'F8' will act as special key (play/pause).
echo "options hid_apple fnmode=2" | sudo tee /etc/modprobe.d/hid_apple.conf

# Disable bluetooth autosuspend
echo "options btusb enable_autosuspend=n" | sudo tee /etc/modprobe.d/btusb_disable_autosuspend.conf

# nvidia-drm modeset=1: Enable DRM KMS (Kernel Mode Setting) for NVIDIA to improve Wayland and boot splash compatibility
# nvidia-drm fbdev=1: Enable framebuffer device support for NVIDIA DRM to allow early boot console display
# nvidia NVreg_PreserveVideoMemoryAllocations=1: Preserve video memory across suspend/resume to prevent screen corruption or crashes
echo -e "options nvidia-drm modeset=1\noptions nvidia-drm fbdev=1\noptions nvidia NVreg_PreserveVideoMemoryAllocations=1" | sudo tee /etc/modprobe.d/nvidia.conf

# Config file backup
sudo cp /etc/bluetooth/main.conf /etc/bluetooth/main.conf.bak

# Configure /etc/bluetooth/main.conf
sudo sed -i 's/#ReconnectAttempts=.*/ReconnectAttempts=3/' /etc/bluetooth/main.conf
sudo sed -i 's/#ReconnectIntervals=.*/ReconnectIntervals=1,2,4/' /etc/bluetooth/main.conf
sudo sed -i 's/#FastConnectable.=.*/FastConnectable=true/' /etc/bluetooth/main.conf

xdg-user-dirs-update
