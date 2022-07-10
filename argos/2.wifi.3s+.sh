#!/usr/bin/env bash

STATUS=$(iw dev wlp0s20f3 station dump | grep "beacon loss" | awk '{ print $3 }')
# echo ":signal_strength: <span foreground='#e86f6f'>$STATUS</span>"
echo "<span foreground='#e86f6f'>$STATUS</span> | iconName=network-wireless-connected-symbolic terminal=false"

echo "---"

