#!/bin/zsh

cd $XDG_CACHE_HOME/wezterm
cp tabs.json tabs.json.$(date +%Y%m%d%H%M%S)

if [[ $(ls tabs.json.* | wc -l) -gt 144 ]]; then
  ls -1t tabs.json.* | tail -n 1 | xargs rm
fi

wezterm cli list --format=json > tabs.json
