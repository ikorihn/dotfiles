defaults write -g NSInitialToolTipDelay -integer 0 # ツールチップ表示までのタイムラグをなくす
defaults write -g NSWindowResizeTime 0.1 # ダイアログ表示やウィンドウリサイズ速度を高速化する

defaults write NSGlobalDomain AppleShowScrollBars -string "Always" # スクロールバーを常時表示する
defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false # アプリケーションを終了するときにウィンドウを閉じる
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001 # コンソールアプリケーションの画面サイズ変更を高速にする
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true # F1,F2などのキーを標準のファンクションキーとして使用する
defaults write NSGlobalDomain com.apple.springing.delay -float 0 # スプリングロード遅延を除去する
defaults write NSGlobalDomain com.apple.springing.enabled -bool true # ディレクトリのスプリングロードを有効にする

defaults write ~/Library/Preferences/ByHost/com.apple.controlcenter.plist BatteryShowPercentage -bool true # バッテリー表示を % 表記にする
defaults write com.apple.terminal StringEncodings -array 4 # UTF-8 のみを使用する

sudo nvram StartupMute=%01 # ブート時のサウンドを無効化する
