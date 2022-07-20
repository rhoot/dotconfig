
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

os_like() {
	grep ID_LIKE= /etc/os-release | cut -d= -f2
}

is_fedora() {
	grep ID_LIKE= /etc/os-release | grep -q fedora
	return $?
}

is_arch() {
	grep ID_LIKE= /etc/os-release | grep -q arch
	return $?
}

install_pkgs() {
	case $(os_like) in
		"arch")
			sudo pacman -Syu --noconfirm --needed $@
			;;
		"fedora")
			sudo dnf -qy install $@
			;;
		*)
			printf "\033[31merr: unknown distribution\033[0m\n" > /dev/stderr
			;;
	esac
}
