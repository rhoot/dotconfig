#!/usr/bin/env -S bash -e

source util.sh

get_rofi_fedora() {
	rofi_origin=https://github.com/lbonn/rofi.git
	rofi_repo="$HOME/ext/rofi"

	# clone
	if [ -d "$rofi_repo" ]; then
		pushd "$rofi_repo" > /dev/null
		git checkout wayland
		git pull
		popd > /dev/null
	else
		mkdir -p "$(dirname "$rofi_repo")"
		git clone "$rofi_origin" "$rofi_repo"
	fi

	# dependencies
	sudo dnf -qy builddep rofi
	dnf_install meson wayland-devel wayland-protocols-devel

	# build
	pushd "$rofi_repo"
	rm -rf build
	meson setup build
	ninja -C build

	# install
	sudo cp "$rofi_repo/build/rofi" /usr/local/bin/rofi
}

if ! has_bin rofi; then
	if has_bin yay; then
		yay_install rofi-lbonn-wayland
	elif is_fedora; then
		get_rofi_fedora
	fi
fi

