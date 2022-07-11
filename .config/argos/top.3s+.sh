#!/usr/bin/env bash

LOAD="$( grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {printf "%.0f\n", usage}' )"
echo "$LOAD%"
echo "---"

if [ "$ARGOS_MENU_OPEN" == "true" ]; then
  TOP_OUTPUT=$(top -b -n 1 | head -n 20 | awk 1 ORS="\\\\n")
  echo "$TOP_OUTPUT | font=monospace bash=top"
else
  echo "Loading..."
fi
