#!/bin/sh

# Gradually dim all connected displays from 100% to 20% brightness over ~4 seconds
outputs=$(xrandr | grep ' connected' | awk '{print $1}')
for b in 0.9 0.8 0.7 0.6 0.5 0.4 0.3 0.2; do
    for output in $outputs; do
        xrandr --output "$output" --brightness "$b"
    done
    sleep 0.5
done
