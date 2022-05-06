#!/usr/bin/env -S bash -e

source util.sh

add_symlink ~/.config/dunst dunst
sudo dnf -qy install dunst

