# Minimal Arch Install

## Script 
The script basically does all this automatically. Please open and read the script before the 1st run, it can wipe your data, beware!

## General install steps
1. Connect to the internet

    Connecting to a network with ```iwcl``` or wired connecting
   
    Update system clock 
2. Create partitions and mount them

   Creating partitions using ```cfdisk```, format and mount
  
3. Install arch

   Installing arch using ```pacstrap```

   Config ```fstab timezone locale-gen keyboard-layout hostname hosts networkmanager initramfs grub```

4. Config it

## Pre-Install and connect to the internet
Load pt keyboard
```
loadkeys us
```

Wireless configuration
```iwctl```
* List devices
```device list```
* Scan networks
```station [device] scan```
* Get avaiable networks
```station [device] get-networks```
* Connect to a networks
```station [device] connect [SSID]```
* Check connection
```ping www.google.com```

Update system clock
```
timedatectl set-ntp true
```

## Disk partition
My default config with 3 partitions
Open ```cfdisk``` and create
* boot with at least 1G, should be /dev/sdaX
* swap with at least 8GB, should be /dev/sdaX
* root with the remaining, should be /dev/sdaX
* home at different disk, should be /dev/sdbX

Format the partitions 
```
mkfs.fat -F32 /dev/sdaX # BOOT
mkswap /dev/sdaX  # SWAP
mkfs.ext4 /dev/sdaX # ROOT
mkfs.ext4 /dev/sdbX # HOME
``` 
and mount them
```
mount /dev/sdaX /mnt  # ROOT
mkdir /mnt/{boot,home}
mount /dev/sdaX /mnt/boot # ROOT
mount /dev/sdbX /mnt/home # HOME
swapon /dev/sdaX 
```

## Install Arch
#### Install base system and extras 
```
pacstrap /mnt base linux linux-firmware networkmanager efibootmgr vim  
```

#### Install Microcode - https://wiki.archlinux.org/index.php/Microcode

>Processor manufacturers release stability and security updates to the processor microcode. These updates provide bug fixes that can be critical to the stability of your system. Without them, you may experience spurious crashes or unexpected system halts that can be difficult to track down.

Amd: amd-ucode or Intel: intel-ucode
```
pacstrap /mnt intel-ucode
```

#### Generate fstab - https://wiki.archlinux.org/index.php/Fstab

>The fstab file can be used to define how disk partitions, various other block devices, or remote filesystems should be mounted into the filesystem.

```
genfstab -U /mnt >> /mnt/etc/fstab
```

#### ```chroot``` into the new system - https://wiki.archlinux.org/index.php/Chroot

>A chroot is an operation that changes the apparent root directory for the current running process and their children.

```
arch-chroot /mnt
```

#### Set the time zone - https://wiki.archlinux.org/index.php/System_time#Time_zone
```
timedatectl set-timezone Europe/Kiev
```

#### Generate /etc/adjtime - https://wiki.archlinux.org/index.php/System_time#Set_hardware_clock_from_system_clock - https://man.archlinux.org/man/hwclock.8#The_Adjtime_File

>The following sets the hardware clock from the system clock. Additionally it updates /etc/adjtime or creates it if not present.

```
hwclock --systohc
```

#### Select locale

>Locales are used by glibc and other locale-aware programs or libraries for rendering text, correctly displaying regional monetary values, time and date formats, alphabetic idiosyncrasies, and other locale-specific standards.

Uncomment the locale needed

```
nano /etc/locale.gen
```
Generate it
```
locale-gen
```
#### Create locale.conf and set the language - https://wiki.archlinux.org/index.php/Locale#Setting_the_system_locale


>To set the system locale, write the LANG variable to /etc/locale.conf, where en_US.UTF-8 belongs to the first column of an uncommented entry in /etc/locale.gen
```
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
```

#### Set keyboard layout
```
echo "KEYMAP=us" >> /etc/vconsole.conf
```

#### Set hostname - https://wiki.archlinux.org/index.php/Network_configuration#Set_the_hostname

>A hostname is a unique name created to identify a machine on a network, configured in /etc/hostname

```
echo "localhost" >> /etc/hostname
```

#### Config /etc/hosts - https://wiki.archlinux.org/index.php/Network_configuration#Local_hostname_resolution
```
127.0.0.1    localhost
::1          localhost
127.0.1.1    localhost.localdomain     localhost
```
```
echo -e "127.0.0.1	localhost\n::1		localhost\n127.0.1.1	localhost.localdomain	localhost" >> /etc/hosts
```

#### Enable networkmanager service - https://wiki.archlinux.org/index.php/networkmanager

>NetworkManager is a program for providing detection and configuration for systems to automatically connect to networks.
```
systemctl enable NetworkManager.service
```

#### Recreate initramfs - https://wiki.archlinux.org/index.php/Arch_boot_process#initramfs
```
mkinitcpio -P
```

#### Config bootloader - https://wiki.archlinux.org/index.php/Arch_boot_process#Boot_loader

>A boot loader is a piece of software started by the firmware (BIOS or UEFI). It is responsible for loading the kernel with the wanted kernel parameters, and initial RAM disk based on configuration files. In the case of UEFI, the kernel itself can be directly launched by the UEFI using the EFI boot stub. A separate boot loader or boot manager can still be used for the purpose of editing kernel parameters before booting.

Systemd-boot - https://wiki.archlinux.org/title/Systemd-boot
```
bootctl install
```

Generate main config file for systemd-boot
```
cd /boot
cd ./loader
echo -e "timeout 3\ndefault arch.conf" > ./loader.conf
cd ./entries
touch arch.conf
echo -e "Title Arch Linux\nlinux /vmlinuz-linux\ninitrd /initramfs-linux.img\n options root=UUID=<ROOT UUID HERE (r!<command> to paste command result in VIM)> rw
```

#### Set root password
```
passwd
```

#### Exit chroot and reboot!
```
exit && reboot
```

#### Arch should now be installed, login with root

## Config the new install
#### Install sudo and bash completion
sudo - https://wiki.archlinux.org/index.php/Sudo
>Sudo allows a system administrator to delegate authority to give certain users—or groups of users—the ability to run commands as root or another user while providing an audit trail of the commands and their arguments.

bash-completion - https://wiki.archlinux.org/index.php/Bash#Tab_completion
>Tab completion is the option to auto-complete typed commands by pressing Tab (enabled by default).
```
pacman -S sudo bash-completion
```

#### Edit sudoers and remove the comment on %wheel - https://wiki.archlinux.org/index.php/Sudo#Using_visudo
>The configuration file for sudo is /etc/sudoers. It should **always** be edited with the visudo command
```
visudo
```
```
## Uncomment to allow members of group wheel to execute any command
%wheel ALL=(ALL) ALL
```
#### Create user and add them to wheel group - https://wiki.archlinux.org/index.php/sudo#Example_entries
>When creating new administrators, it is often desirable to enable sudo access for the wheel group and add the user to it, since by default Polkit treats the members of the wheel group as administrators. If the user is not a member of wheel, software using Polkit may ask to authenticate using the root password instead of the user password.
```
useradd -m -G wheel <username>
```

#### Add a password to the new created user
```
passwd <username>
```

#### Exit root and login with new user
```
exit
```

#### Test permissions of the new user
```
sudo pacman -Syu
```

#### At this point, arch is installed and ready to use, although it is very *very* bare bones. Highly recommended installing atleast a firewall and a WM, like i3 or a DE like xfce.

### Extras
