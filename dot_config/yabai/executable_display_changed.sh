#!/usr/bin/env zsh

width=$(yabai -m query --displays --display | jq '.frame.w | floor')

if [[ ${width} -lt 2000 ]]; then
  yabai -m config left_padding 0 right_padding 0
elif [[ ${width} -gt 3000 ]]; then
  yabai -m config left_padding 192 right_padding 192
else
  yabai -m config left_padding 32 right_padding 32
fi
