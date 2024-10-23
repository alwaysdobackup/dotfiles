#! /bin/sh

rofi_cmd() {
	rofi -dmenu \
		-theme ~/.config/rofi/menu_bottom.rasi
}

chosen=$(printf "⏻ Poweroff\n󰜉 Reboot\n󰤄 Suspend\n󰗼 Log out" | rofi_cmd)

case "$chosen" in

	"⏻ Poweroff") systemctl poweroff ;;
	"󰜉 Reboot") systemctl reboot ;;
	"󰤄 Suspend") systemctl suspend ;;
	"󰗼 Log out") bspc quit ;;
	*) exit 1 ;;

esac
