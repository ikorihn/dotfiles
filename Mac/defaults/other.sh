# -gとNSGlobalDomainは同じ項目を変更する
defaults write -g NSInitialToolTipDelay -integer 0 # ツールチップ表示までのタイムラグをなくす
defaults write -g NSWindowResizeTime 0.1 # ダイアログ表示やウィンドウリサイズ速度を高速化する

defaults write -g AppleShowScrollBars -string "Always" # スクロールバーを常時表示する
defaults write -g NSQuitAlwaysKeepsWindows -bool false # アプリケーションを終了するときにウィンドウを閉じる
defaults write -g NSWindowResizeTime -float 0.001 # コンソールアプリケーションの画面サイズ変更を高速にする
defaults write -g com.apple.keyboard.fnState -bool true # F1,F2などのキーを標準のファンクションキーとして使用する
defaults write -g com.apple.springing.delay -float 0 # スプリングロード遅延を除去する
defaults write -g com.apple.springing.enabled -bool true # ディレクトリのスプリングロードを有効にする

defaults write ~/Library/Preferences/ByHost/com.apple.controlcenter.plist BatteryShowPercentage -bool true # バッテリー表示を % 表記にする
defaults write com.apple.terminal StringEncodings -array 4 # UTF-8 のみを使用する

# Sound
sudo nvram StartupMute=%01 # ブート時のサウンドを無効化する
defaults write -g com.apple.sound.beep.feedback -bool true # volume変更時のフィードバック音
defaults write -g com.apple.sound.beep.volume -int 0 # Alert volume ECSやDeleteを押したときのbeep音
defaults write -g com.apple.sound.uiaudio.enabled -bool false # Play user inetrface sound effects

