#!/bin/sh

# Colors below are from the Kanagawa Dragon theme
# (see ~/.config/alacritty/kanagawa/dragon.toml).
# Resolved through any symlink: the entry point is symlinked onto PATH, while
# saver_solid sits next to this file rather than next to the symlink.
DIR="$(dirname -- "$(readlink -f -- "$0")")"
SAVER_SOLID_COLOR='#181616' \
XSECURELOCK_SAVER="$DIR/saver_solid" \
XSECURELOCK_FONT="Ubuntu Mono" \
XSECURELOCK_AUTH_BACKGROUND_COLOR='#181616' \
XSECURELOCK_AUTH_FOREGROUND_COLOR='#c5c9c5' \
XSECURELOCK_AUTH_WARNING_COLOR='#c4746e' \
exec xsecurelock
