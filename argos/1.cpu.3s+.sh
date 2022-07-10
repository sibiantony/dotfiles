#!/usr/bin/env bash

STATUS=$(cat /proc/cpuinfo | grep MHz | awk '{ total += $4; count++ } END { printf("%.2f", total/(count*1000)) }')
LOAD_PROCFS=$( load=`grep 'cpu ' /proc/stat && sleep 0.1 && grep 'cpu ' /proc/stat`; echo $load | awk '{ printf "%.0f", ($13-$2+$15-$4)*100/($13-$2+$15-$4+$16-$5) }' )
echo "$LOAD_PROCFS% $STATUS GHz | iconName=drive-harddisk-solidstate-symbolic"

echo "---"

if [ "$ARGOS_MENU_OPEN" == "true" ]; then
  CPU_OUTPUT=$(cat /proc/cpuinfo | grep MHz | awk '{ print $4 }' | sort -n | xargs echo -n)
  echo "$CPU_OUTPUT | font=monospace"
  echo "---"
  TOP_OUTPUT=$(top -b -n 1 | head -n 20 | awk 1 ORS="\\\\n")
  echo "$TOP_OUTPUT | font=monospace bash=top"
  echo "---"
  SCALING_STATUS=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor`
  echo "Toggle <span color='#a6dba0'><tt>$SCALING_STATUS</tt></span> | iconName=gnome-power-manager-symbolic bash='source ~/.bashrc && powerscale' terminal=false"
  
  BAT_OUTPUT=$(upower -d | grep 'AC' -A 3 | grep updated  | awk -F'updated:' '{ print $2 }' | awk '{ print $5" "$6 }')
  echo "Last plug/unplug : $BAT_OUTPUT | terminal=false"
else
  echo "Loading..."
fi

