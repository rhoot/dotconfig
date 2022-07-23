#!/usr/bin/env -S bash -e

rsync -r fonts/ ~/.local/share/fonts

if which pacman > /dev/null 2>&1; then
	sudo pacman -Syu --noconfirm --needed otf-font-awesome
fi
