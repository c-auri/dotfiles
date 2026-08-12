#!/usr/bin/env bash

# Picks an emoji via rofi, copies it to clipboard, and types it into the focused window

dir="$HOME/.config/rofi/emoji"

focused=$(xdotool getactivewindow 2>/dev/null)

# rofi scores a row by the entire string it displays, and charges 5 points for
# every character following the match, so a visible full Unicode name drags its
# own short name below unrelated rows. The sed moves the trailing "(full name)"
# into rofi's dmenu meta field, whose wire format is the row text, a NUL, the
# key "meta", a US byte (\x1f), then the terms. Meta is searched only when the
# visible text does not match, and is never scored, which makes the full name a
# strict fallback. See README.md.
selected=$(sed -E 's/ \((.*)\)$/\x00meta\x1f\1/' "$dir/emojis.txt" | rofi -dmenu \
    -p "❯" \
    -i \
    -no-custom \
    -scroll-method 1 \
    -sort \
    -sorting-method fzf \
    -theme "$dir/style.rasi")

[ -z "$selected" ] && exit 0

emoji=$(printf '%s' "$selected" | awk '{print $1}')

printf '%s' "$emoji" | xclip -selection clipboard

if [ -n "$focused" ]
then
    xdotool windowfocus --sync "$focused"
    xdotool type --clearmodifiers -- "$emoji"
fi
