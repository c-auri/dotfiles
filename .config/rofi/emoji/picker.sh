#!/usr/bin/env bash

# Picks an emoji via rofi, copies it to clipboard, and types it into the focused window

dir="$HOME/.config/rofi/emoji"

focused=$(xdotool getactivewindow 2>/dev/null)

selected=$(rofi -dmenu \
    -p "❯" \
    -i \
    -no-custom \
    -markup-rows \
    -scroll-method 1 \
    -sort \
    -sorting-method fzf \
    -theme "$dir/style.rasi" < "$dir/emojis.txt")

[ -z "$selected" ] && exit 0

emoji=$(printf '%s' "$selected" | awk '{print $1}')

printf '%s' "$emoji" | xclip -selection clipboard

if [ -n "$focused" ]
then
    xdotool windowfocus --sync "$focused"
    xdotool type --clearmodifiers -- "$emoji"
fi
