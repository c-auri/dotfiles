#!/usr/bin/env bash

# Opens a rofi application launcher

dir="$(dirname "$(readlink -f "$0")")"

rofi -show drun -theme "$dir/style.rasi"
