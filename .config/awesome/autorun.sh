#!/bin/sh

# Starts background services needed by the AwesomeWM session

run() {
    if ! pgrep -f "$1"
    then
        "$@" &
    fi
}

# Auto-lock on idle (skip if LOCK_IDLE_DISABLE=1)
if [ "${LOCK_IDLE_DISABLE}" != "1" ]
then
    run xidlehook \
        --not-when-fullscreen \
        --timer 180 \
            "lockscreen-dim" \
            "lockscreen-undim" \
        --timer 120 \
            "lockscreen-undim && lockscreen" \
            ""
fi
