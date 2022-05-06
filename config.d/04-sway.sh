#!/usr/bin/env -S bash -e

source util.sh

sudo dnf -qy install \
	alacritty \
	blueman \
	byobu \
	grim \
	network-manager-applet \
	playerctl \
	pulseaudio-utils \
	slurp \
	swaybg \
	swayidle \
	swaylock \
	thunar \
	tmux

add_symlink ~/.config/sway sway
sudo cp sway/sway.sh /usr/local/bin/sway.sh
sudo sed -iE 's/^Exec=sway$/Exec=sway.sh/' /usr/share/wayland-sessions/sway.desktop

