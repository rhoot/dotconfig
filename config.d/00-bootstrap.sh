#!/usr/bin/env -S bash -e

source util.sh

# Copy all the fonts
mkdir -p ~/.local/share/fonts
rsync -r fonts/ ~/.local/share/fonts

# Symlink all the .configs
for n in $(ls configs); do
	add_symlink ~/.config/$n configs/$n
done

# Install packages
install_pkgs \
	blueman \
	grim \
	kitty \
	mako \
	network-manager-applet \
	playerctl \
	slurp \
	swappy \
	swayidle \
	swaylock \
	thunar

# Arch packages
pacman_install libpulse otf-font-awesome yay
yay_install sway-git swaybg-git wlroots-git

# Fedora packages
dnf_install pulseaudio-utils sway swaybg
