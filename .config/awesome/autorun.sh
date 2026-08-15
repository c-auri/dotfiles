#!/bin/sh

# Starts background services needed by the AwesomeWM session

# Guarded because rc.lua is evaluated again on every awesome restart, so this
# script runs once per restart and must not start a second copy.
#
# pgrep -x matches the process name exactly. With -f it also matched any
# command line that merely mentioned the daemon, an editor or a grep included,
# and then skipped starting it: a false positive here means no service and no
# error.
#
# The daemon deliberately stays in this session rather than being detached with
# setsid. Detaching makes it outlive logout, and the next session's guard then
# finds that stale process, skips the start, and leaves the new session with a
# daemon bound to an X server that no longer exists.
run() {
    if ! pgrep -x "$1" >/dev/null
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
