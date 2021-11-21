#!/bin/bash -e

script_dir="$(dirname "$(readlink -f "$0")")"

add_symlink() {
	local name="$1"
	local path="$HOME/.config/$name"

	if [ -h "$path" ]; then
		rm "$path"
	fi

	if [ -e "$path" ]; then
		printf "\033[31merr: '%s' exists and would be overwritten\033[0m\n" "$path" > /dev/stderr
	fi

	ln -s "$script_dir/$name" "$path"
}

add_symlink i3
add_symlink polybar
rsync -r "$script_dir/fonts/" ~/.local/share/fonts

