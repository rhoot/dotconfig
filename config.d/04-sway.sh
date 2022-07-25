#!/usr/bin/env -S bash -e

source util.sh

# Write a custom launch script for sway to set environment variables
sudo tee /usr/local/bin/sway.sh > /dev/null <<'EOT'
#!/usr/bin/env bash

export SDL_VIDEODRIVER=wayland
export _JAVA_AWT_WM_NONREPARENTING=1
export QT_QPA_PLATFORM=wayland
export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_DESKTOP=sway

# systemd environment.d env variables
# https://github.com/systemd/systemd/issues/7641
if [ -f /usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator ]; then
	set -a
	. /dev/fd/0 <<EOF
$(/usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator)
EOF
	set +a
fi

exec sway "$@"
EOT

# Make the sway wayland session run the script instead of the executable
sudo sed -iE 's/^Exec=sway$/Exec=sway.sh/' /usr/share/wayland-sessions/sway.desktop

# Sway requires a background if the config specifies one, so create one if it doesn't exist
if [ ! -f ~/.config/wallpaper.png ]; then
	cp files/black.png ~/.config/wallpaper.png
fi
