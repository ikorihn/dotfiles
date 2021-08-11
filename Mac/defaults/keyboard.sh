defaults write NSGlobalDomain InitialKeyRepeat -int 15 # キーリピート開始までのタイミング
defaults write NSGlobalDomain KeyRepeat -int 2 # キーリピートの速度

# ========== Adjust keyboard brightness in low light ==========
NPLIST="/private/var/root/Library/Preferences/com.apple.CoreBrightness.plist"
# - Checked
# sudo /usr/libexec/PlistBuddy -c "Set :KeyboardBacklight:KeyboardBacklightABEnabled 1" ${NPLIST}
# - Unchecked
sudo /usr/libexec/PlistBuddy -c "Set :KeyboardBacklight:KeyboardBacklightABEnabled 0" ${NPLIST}

# ========== Turn keyboard backlight off after ~~~ of inactivity ==========
# @int:second
sudo /usr/libexec/PlistBuddy -c "Set :KeyboardBacklight:KeyboardBacklightIdleDimTime 0" ${NPLIST}

