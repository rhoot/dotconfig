#!/usr/bin/env -S bash -e

if [[ $UID == 0 ]]; then
	>&2 echo "Don't run this script as root."
	exit 1
fi

# Make sure to always ask for sudo creds for communication that sudo is happening.
sudo -k

script_dir="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
echo $script_dir

for script in $(ls "$script_dir"/config.d/*.sh)
do
	script="$(basename "$script")"
	echo -e "\033[1m>> \033[36m$script\033[0m"
	"$script_dir/config.d/$script"
done
