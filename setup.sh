#!/usr/bin/env -S bash -e

os_release_id="$(source /etc/os-release && echo $ID)"
script_dir="$(dirname "$(readlink -f "$0")")"

if [ "$os_release_id" != "fedora" ]; then
	printf "\033[31mERR: This script was written for Fedora\033[0m\n" > /dev/stderr
	exit 1
fi

###
# Config
###

i3_gaps_commit=1f6bf271ddc8ba8aed8c225350e965fda75dcf5f
picom_commit=1c7a4ff5a3cd5f3e25abcac0196896eea5939dce

i3_config_dependencies=( \
	alacritty \
	byobu \
	feh \
	flameshot \
	fontawesome-fonts \
	network-manager-applet \
	playerctl \
	polybar \
	pulseaudio-utils \
	rofi \
	thunar \
)

###
# Setup
###

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

install_config_dependencies() {
	sudo dnf -y install ${i3_config_dependencies[*]}
}

build_and_install() {
	local repo="$1"
	local folder_name="$2"
	local binary_name="$3"
	local commit_id="$4"

	if [ ! -f "/usr/local/bin/$binary_name" ]; then
		mkdir -p ~/Git/ext
		pushd ~/Git/ext

		if [ ! -d "$folder_name" ]; then
			git clone "$repo" "$folder_name"
		fi

		cd "$folder_name"
		git reset --hard
		git clean -ffxd
		git checkout "$commit_id"

		if [ ! -f build/build.ninja ]; then
			meson --buildtype=release . build
		fi

		sudo ninja -C build install
		popd
	fi
}

build_i3_gaps() {
	sudo dnf -y install \
		i3lock \
		i3status \
		libXinerama-devel \
		libXrandr-devel \
		libev-devel \
		libxcb-devel \
		libxkbcommon-devel \
		libxkbcommon-x11-devel \
		meson \
		ninja-build \
		pango-devel \
		pcre-devel \
		perl-ExtUtils-MakeMaker \
		startup-notification-devel \
		xcb-util-cursor-devel \
		xcb-util-devel \
		xcb-util-keysyms-devel \
		xcb-util-wm-devel \
		xcb-util-xrm-devel \
		yajl-devel

	build_and_install https://github.com/Airblader/i3.git i3-gaps i3 $i3_gaps_commit
}

build_picom() {
	sudo dnf -y install \
		dbus-devel \
		gcc \
		git \
		libconfig-devel \
		libdrm-devel \
		libev-devel \
		libX11-devel \
		libX11-xcb \
		libXext-devel \
		libxcb-devel \
		mesa-libGL-devel \
		meson \
		pcre-devel \
		pixman-devel \
		uthash-devel \
		xcb-util-image-devel \
		xcb-util-renderutil-devel \
		xorg-x11-proto-devel

	build_and_install https://github.com/yshui/picom.git picom picom $picom_commit
}

install_fonts() {
	rsync -r "$script_dir/fonts/" ~/.local/share/fonts
}

add_symlink i3
add_symlink polybar
install_config_dependencies
install_fonts
build_i3_gaps
build_picom
