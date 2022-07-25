
# add_symlink(link, target)
add_symlink() {
	local from="$(realpath --no-symlinks "$1")"
	local to="$(realpath --no-symlinks "$2")"

	if [ -h "$from" ]; then
		rm "$from"
	fi

	if [ -e "$from" ]; then
		printf "\033[31merr: '%s' exists and would be overwritten\033[0m\n" "$from" > /dev/stderr
		return 1
	fi

	ln -s "$to" "$from"
}

# find_upward(start, cond, name)
find_upward() {
	pushd "$1" > /dev/null
	while true; do
		if [ "${@:2}" ]; then
			echo $(realpath "$3")
			popd > /dev/null
			return 0
		fi
		if [ "$PWD" == / ]; then
			popd > /dev/null
			return 1
		fi
		cd ..
	done
}

# has_bin(name)
has_bin() {
	which "$1" > /dev/null 2>&1
	return $?
}

# os_like()
os_like() {
	grep ID_LIKE= /etc/os-release | cut -d= -f2
}

# is_fedora()
is_fedora() {
	grep ID_LIKE= /etc/os-release | grep -q fedora
	return $?
}

# is_arch()
is_arch() {
	grep ID_LIKE= /etc/os-release | grep -q arch
	return $?
}

# pacman_install(pkgs...)
pacman_install() {
	if has_bin pacman; then
		sudo pacman -Syu --noconfirm --needed $@
	fi
}

# dnf_install(pkgs...)
dnf_install() {
	if has_bin dnf; then
		sudo dnf -qy install $@
	fi
}

# yay_install(pkgs...)
yay_install() {
	if has_bin yay; then
		# There doesn't seem to be a way to have yay ignore already installed packages so... filter
		# the installed packages manually...
		pkgs=("$@")
		for index in "${!pkgs[@]}"; do
			yay -Qm "${pkgs[$index]}" > /dev/null 2>&1 && unset -v 'pkgs[$index]'
		done
		yay -S "${pkgs[@]}"
	fi
}

# install_pkgs(pkgs...)
install_pkgs() {
	dnf_install "$@"
	pacman_install "$@"
}
