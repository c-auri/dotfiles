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

# Auto-lock on idle.

dim_after="$IDLE_DIM_AFTER_SECONDS"
lock_after_dim="$IDLE_LOCK_SECONDS_AFTER_DIM"

# The case guards cover unset, empty, and non-numeric alike.
# xidlehook refuses to start on a bad duration,
# so a typo would otherwise cost the lock entirely.
case "$dim_after" in ''|*[!0-9]*) dim_after=180 ;; esac
case "$lock_after_dim" in ''|*[!0-9]*) lock_after_dim=10 ;; esac

# Lower bounds that catch values that are numeric but nonsensical. Locking within
# a few seconds of going idle is far harder to back out of than a mistimed lock,
# because every attempt to fix it races the timer that keeps re-locking.
[ "$dim_after" -ge 10 ] || dim_after=180
[ "$lock_after_dim" -ge 1 ] || lock_after_dim=10

set -- --not-when-fullscreen \
    --timer "$dim_after" \
        "lockscreen-dim" \
        "lockscreen-undim"

if [ "$IDLE_LOCK_DISABLE" != "1" ]
then
    set -- "$@" \
        --timer "$lock_after_dim" \
            "lockscreen-undim && lockscreen" \
            ""
fi

if [ "$IDLE_DIM_DISABLE" != "1" ]
then
    run xidlehook "$@"
fi
