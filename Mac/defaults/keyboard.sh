defaults write NSGlobalDomain InitialKeyRepeat -int 15 # キーリピート開始までのタイミング
defaults write NSGlobalDomain KeyRepeat -int 2 # キーリピートの速度

# # ========== Adjust keyboard brightness in low light ==========
# NPLIST="/private/var/root/Library/Preferences/com.apple.CoreBrightness.plist"
# # - Checked
# # sudo /usr/libexec/PlistBuddy -c "Set :KeyboardBacklight:KeyboardBacklightABEnabled 1" ${NPLIST}
# # - Unchecked
# sudo /usr/libexec/PlistBuddy -c "Set :KeyboardBacklight:KeyboardBacklightABEnabled 0" ${NPLIST}
#
# # ========== Turn keyboard backlight off after ~~~ of inactivity ==========
# # @int:second
# sudo /usr/libexec/PlistBuddy -c "Set :KeyboardBacklight:KeyboardBacklightIdleDimTime 0" ${NPLIST}
#

####
# shortcuts
####
# Turn Dock Hiding On/Off
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 52 "<dict><key>enabled</key><false/></dict>"
# Turn VoiceOver on / off - Command, F5
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 59 "<dict><key>enabled</key><false/></dict>"
# Select the previous input source
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 60 "<dict><key>enabled</key><false/></dict>"
# Select the next source in the Input Menu
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 61 "<dict><key>enabled</key><false/></dict>"
# Show Finder search window
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 65 "<dict><key>enabled</key><false/></dict>"
# Switch to Desktop 1
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 118 "<dict><key>enabled</key><false/></dict>"
# Show accessibility controls
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 162 "<dict><key>enabled</key><false/></dict>"
# Quick Note
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 190 "<dict><key>enabled</key><false/></dict>"

# Turn Do Not Disturb On/Off
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 175 "
  <dict>
    <key>enabled</key><true/>
    <key>value</key><dict>
      <key>type</key><string>standard</string>
      <key>parameters</key>
      <array>
        <integer>65535</integer>
        <integer>103</integer>
        <integer>9437184</integer>
      </array>
    </dict>
  </dict>
"

# Move focus to next window
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 27 "
  <dict>
    <key>enabled</key><true/>
    <key>value</key><dict>
      <key>type</key><string>standard</string>
      <key>parameters</key>
      <array>
        <integer>65535</integer>
        <integer>48</integer>
        <integer>524288</integer>
      </array>
    </dict>
  </dict>
"

# Press Global(fn) to
defaults write com.apple.HIToolbox AppleFnUsageType 0
