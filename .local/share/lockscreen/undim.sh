#!/bin/sh

for output in $(xrandr | grep ' connected' | awk '{print $1}'); do
    xrandr --output "$output" --brightness 1
done
