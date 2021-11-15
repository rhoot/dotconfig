#!/usr/bin/env sh

# Forces a restart of polybar

killall -q polybar
while pgrep -x polybar > /dev/null; do sleep 1; done
polybar top &
