#!/bin/sh

# Colors below are from the Kanagawa Dragon theme
# (see ~/.config/alacritty/kanagawa/dragon.toml).
DIR="$(cd -- "$(dirname -- "$0")" && pwd)"
SAVER_SOLID_COLOR='#181616' \
XSECURELOCK_SAVER="$DIR/saver_solid" \
XSECURELOCK_FONT="Ubuntu Mono" \
XSECURELOCK_AUTH_BACKGROUND_COLOR='#181616' \
XSECURELOCK_AUTH_FOREGROUND_COLOR='#c5c9c5' \
XSECURELOCK_AUTH_WARNING_COLOR='#c4746e' \
exec xsecurelock
