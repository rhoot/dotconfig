#!/usr/bin/env -S bash -e

source util.sh

add_symlink ~/.config/waybar waybar
sudo dnf -qy install waybar
