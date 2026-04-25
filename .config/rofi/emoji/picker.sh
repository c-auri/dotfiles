#!/usr/bin/env bash
dir="$HOME/.config/rofi/emoji"

focused=$(xdotool getactivewindow 2>/dev/null)

selected=$(cat "$dir/recent.txt" "$dir/emojis.txt" 2>/dev/null | rofi -dmenu \
    -p "❯" \
    -i \
    -no-custom \
    -markup-rows \
    -scroll-method 1 \
    -theme "$dir/style.rasi")

[ -z "$selected" ] && exit 0

emoji=$(printf '%s' "$selected" | awk '{print $1}')

{ echo "$selected"; grep -vxF "$selected" "$dir/recent.txt" 2>/dev/null; } | head -10 > "$dir/recent.tmp"
mv "$dir/recent.tmp" "$dir/recent.txt"

printf '%s' "$emoji" | xclip -selection clipboard

if [ -n "$focused" ]; then
    xdotool windowfocus --sync "$focused"
    xdotool type --clearmodifiers -- "$emoji"
fi
