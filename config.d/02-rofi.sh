#!/usr/bin/env -S bash -e

source util.sh

rofi_origin=https://github.com/lbonn/rofi.git
rofi_repo="$HOME/Git/ext/rofi"

clone_rofi_wayland() {
	if [ -d "$rofi_repo" ]; then
		pushd "$rofi_repo" > /dev/null
		git checkout wayland
		git pull
		popd > /dev/null
	else
		git clone "$rofi_origin" "$rofi_repo"
	fi
}

install_deps() {
	sudo dnf -qy builddep rofi
	sudo dnf -qy install \
		meson \
		wayland-devel \
		wayland-protocols-devel
}

build_rofi() {
	pushd "$rofi_repo"
	rm -rf build
	meson setup build
	ninja -C build
	popd
}

if ! which rofi &> /dev/null; then
	clone_rofi_wayland
	install_deps
	build_rofi
	sudo cp "$rofi_repo/build/rofi" /usr/local/bin/rofi
fi

add_symlink ~/.config/rofi rofi
