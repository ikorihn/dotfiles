#!/usr/bin/env zsh

LEFT_HALF=16:10:0:0:5:16
RIGHT_HALF=16:10:5:0:5:16
TOP_RIGHT=16:10:5:0:5:8
BOTTOM_RIGHT=16:10:5:8:5:8

LEFT_70=16:10:0:0:7:16
RIGHT_70=16:10:3:0:7:16
FULL=1:1:0:0:1:1

function arrange() {
  i=0
  yabai -m query --windows --space | jq -r '.[] | [.id, .app] | @csv' | while read -r WIN; do
    WIN=(${(z)WIN//,/ })
    echo $WIN
    id=${WIN[1]}
    app=${WIN[2]}
    if [[ ${app} =~ (System Settings|Karabiner.*|Finder|Preview|Bitwarden|KeePassXC|カレンダー) ]]; then
      continue
    fi

    if [[ ${app} == '"Vivaldi"' ]]; then
      yabai -m window $id --grid ${LEFT_70}
      continue
    elif [[ ${app} == '"Alacritty"' ]]; then
      yabai -m window $id --grid ${RIGHT_70}
      continue
    fi

    if [[ $(( i % 3 )) -eq 0 ]]; then
      yabai -m window $id --grid ${LEFT_HALF}
    elif [[ $(( i % 3 )) -eq 1 ]]; then
      yabai -m window $id --grid ${RIGHT_HALF}
    else
      yabai -m window $id --grid ${RIGHT_HALF}
    fi
    ((i++))
  done
}

arrange
