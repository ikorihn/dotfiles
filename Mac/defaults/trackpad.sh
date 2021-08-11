# Enable `Tap to click` （タップでクリックを有効にする）
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# 3本指のLook up & data detectors
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerTapGesture -bool false
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerTapGesture -bool false

# ドラッグロック
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Dragging -bool true

# 右クリック
# - Checked
#  - Click or tap with two fingers
defaults write .GlobalPreferences ContextMenuGesture -int 1
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 0
#  - Click in bottom right corner
# defaults write .GlobalPreferences ContextMenuGesture -int 1
# defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool false
# defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -int 2
# defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool false
# defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
#  - Click in bottom left corner
# defaults write .GlobalPreferences ContextMenuGesture -int 1
# defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool false
# defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -int 1
# defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool false
# defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 1
# - Unchecked
# defaults write .GlobalPreferences ContextMenuGesture -int 0
# defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool false
# defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -int 0
# defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool false
# defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 0

# スクロール方向
defaults write .GlobalPreferences com.apple.swipescrolldirection -bool true

# zoom
defaults write com.apple.AppleMultitouchTrackpad TrackpadPinch -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadPinch -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerDoubleTapGesture -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerDoubleTapGesture -bool true
