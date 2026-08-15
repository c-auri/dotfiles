#!/bin/sh

# Stop a fade that is still in progress before restoring brightness. Without
# this, dim.sh's next step overwrites the reset half a second later and the
# display keeps dimming even though activity resumed.
pidfile="${XDG_RUNTIME_DIR:-/tmp}/lockscreen-dim.pid"
if [ -f "$pidfile" ]
then
    kill "$(cat "$pidfile")" 2>/dev/null
    rm -f "$pidfile"
fi

for output in $(xrandr | grep ' connected' | awk '{print $1}'); do
    xrandr --output "$output" --brightness 1
done
