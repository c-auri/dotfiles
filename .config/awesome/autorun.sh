#!/bin/sh

run() {
    if ! pgrep -f "$1"; then
        "$@" &
    fi
}

# Auto-lock on idle (skip if LOCK_IDLE_DISABLE=1)
if [ "${LOCK_IDLE_DISABLE}" != "1" ]; then
    run xidlehook \
        --not-when-fullscreen \
        --timer 180 \
            "$HOME/.config/awesome/lockscreen/dim.sh" \
            "$HOME/.config/awesome/lockscreen/undim.sh" \
        --timer 120 \
            "$HOME/.config/awesome/lockscreen/undim.sh && $HOME/.config/awesome/lockscreen/lock.sh" \
            ""
fi
