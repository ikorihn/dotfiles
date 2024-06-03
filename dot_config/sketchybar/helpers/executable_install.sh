# Packages
brew install lua switchaudio-osx nowplaying-cli
brew install --cask sf-symbols

# symbol font for skechybar
curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.19/sketchybar-app-font.ttf -o $HOME/Library/Fonts/sketchybar-app-font.ttf
curl -L https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v2.0.19/icon_map.lua -o ~/.config/sketchybar/icon_map.lua

# SbarLua
(git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua && cd /tmp/SbarLua/ && make install && rm -rf /tmp/SbarLua/)
