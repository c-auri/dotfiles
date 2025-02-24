#!/bin/sh

run() {
    if ! pgrep -f "$1"; then
        "$@" &
    fi
}

# disable blank screen
xset s off
xset -dpms
xset s noblank
