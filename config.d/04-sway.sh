#!/usr/bin/env -S bash -e

source util.sh

case $(os_like) in
	"arch")
		install_pkgs libpulse yay
		yay -S sway-git swaybg-git wlroots-git
		;;
	"fedora")
		install_pkgs pulseaudio-utils sway swaybg
		;;
esac

install_pkgs \
	alacritty \
	blueman \
	byobu \
	grim \
	network-manager-applet \
	playerctl \
	slurp \
	swayidle \
	swaylock \
	thunar \
	tmux

add_symlink ~/.config/sway sway
sudo cp sway/sway.sh /usr/local/bin/sway.sh
sudo sed -iE 's/^Exec=sway$/Exec=sway.sh/' /usr/share/wayland-sessions/sway.desktop

# sway _requires_ a background if the config has one, so create it if it doesn't exist
if [ ! -f ~/.config/wallpaper.png ]; then
	largest_image=
	largest_image_x=0

	for f in $(find /usr/share/wallpapers -name '*.jpg' -or -name '*.png'); do
		image_x=$(convert "$f" -print "%w" /dev/null)

		if [ $image_x -gt $largest_image_x ]; then
			largest_image="$f"
			largest_image_x=$image_x
		fi
	done

	if [ -z "$largest_image" ]; then
		echo "Remember to set a wallpaper!"
		read
	elif [[ "$largest_image" == *.jpg ]]; then
		convert "$largest_image" ~/.config/wallpaper.png
	else
		cp "$largest_image" ~/.config/wallpaper.png
	fi
fi
