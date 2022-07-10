#!/usr/bin/env bash

# Add text to copy to clipboard
# Example
ASCII_SHRUG="¯\\\\_\(ツ\)_/¯"
echo " | iconName=edit-paste-symbolic"
echo "---"
echo "$ASCII_SHRUG | font=monospace bash='echo -n $ASCII_SHRUG | xclip -selection clipboard' terminal=false"
echo "---"

