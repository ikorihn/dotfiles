defaults write com.apple.dock autohide -bool true # Automatically hide or show the Dock （Dock を自動的に隠す）
defaults write com.apple.dock autohide-delay -float 0 # Dock が表示されるまでの待ち時間を無効にする
defaults write com.apple.dock magnification -bool false # Magnificate the Dock （Dock の拡大機能を入にする）
defaults write com.apple.dock mineffect -string "scale" # 最小化アニメーション(scale, genie)
defaults write com.apple.dock minimize-to-application -bool true # 最小化した際にアイコンに格納する
defaults write com.apple.dock orientation -string left # Dockの表示場所を変更
defaults write com.apple.dock persistent-apps -array # Wipe all app icons from the Dock （Dock に標準で入っている全てのアプリを消す、Finder とごみ箱は消えない）
defaults write com.apple.dock show-process-indicators -bool true # 起動中アプリのアイコンにindicatorを表示
defaults write com.apple.dock tilesize -int 40 # Set the icon size （アイコンサイズの設定）

# Mission control
defaults write com.apple.dock showAppExposeGestureEnabled -bool true # アプリケーションexpose (3本指で下にスワイプしたときの動作)
defaults write com.apple.dock mru-spaces -bool false # 使用状況に基づいて並び替える
defaults write com.apple.dock expose-group-apps -bool true # ウィンドウをアプリケーションごとにグループ化
defaults write com.apple.spaces spans-displays -bool true # ディスプレイごとに個別のスペース

