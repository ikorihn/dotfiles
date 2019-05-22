# Use a custom theme （カスタムテーマを使う、そのテーマをデフォルトに設定する）
# Use a modified version of the Solarized Dark theme by default in Terminal.app
TERM_PROFILE='Solarized_Dark';
TERM_PATH='./';
CURRENT_PROFILE="$(defaults read com.apple.terminal 'Default Window Settings')";
if [ "${CURRENT_PROFILE}" != "${TERM_PROFILE}" ]; then
    open "$TERM_PATH$TERM_PROFILE.terminal"
    defaults write com.apple.Terminal "Default Window Settings" -string "$TERM_PROFILE"
    defaults write com.apple.Terminal "Startup Window Settings" -string "$TERM_PROFILE"
fi
defaults import com.apple.Terminal "$HOME/Library/Preferences/com.apple.Terminal.plist"

