sudo chflags nohidden /Volumes # /Volumes ディレクトリを見えるようにする
chflags nohidden ~/Library # ~/Library ディレクトリを見えるようにする
defaults write com.apple.finder AnimateWindowZoom -bool false # フォルダを開くときのアニメーションを無効にする
defaults write com.apple.finder AppleShowAllFiles YES # 不可視ファイルを表示する
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf" # 検索時にデフォルトでカレントディレクトリを検索する
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false # 拡張子変更時の警告を無効化する
defaults write com.apple.finder FXPreferredViewStyle Nlsv # 常にリストビューにする
defaults write com.apple.finder FinderSpawnTab -bool true # Open folders in tabs instead of new windows
defaults write com.apple.finder NewWindowTarget -string "PfHm" # 新しいウィンドウでデフォルトでホームフォルダを開く
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/" # 新しいウィンドウでデフォルトでホームフォルダを開く
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true # マウントされたディスクがあったら、自動的に新しいウィンドウを開く
defaults write com.apple.finder QLEnableTextSelection -bool true # クイックルックでテキストを選択可能にする
defaults write com.apple.finder QuitMenuItem -bool true # Finder を終了させる項目を追加する
defaults write com.apple.finder ShowPathbar -bool true # パスバーを表示する
defaults write com.apple.finder ShowStatusBar -bool true # ステータスバーを表示する
defaults write com.apple.finder ShowTabView -bool true # タブバーを表示する
defaults write com.apple.finder ShowRecentTags -bool false # Recent Tags
defaults write com.apple.finder WarnOnEmptyTrash -bool false # ゴミ箱を空にする前の警告を無効化する
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true # Finder のタイトルバーにフルパスを表示する
defaults write com.apple.finder _FXSortFoldersFirst -bool true # 名前で並べ替えを選択時にディレクトリを前に置くようにする

# ボリュームマウント時に自動的にFinderを表示
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true

defaults write -g NSAutomaticWindowAnimationsEnabled -bool false # ファイルを開くときのアニメーションを無効にする
defaults write -g AppleShowAllExtensions -bool true # 全ての拡張子のファイルを表示する

# USB やネットワークストレージに .DS_Store ファイルを作成しない
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# スクリーンショット
defaults write com.apple.screencapture name "screenshot" # 名前を変更
# defaults write com.apple.screencapture include-date -bool false
defaults write com.apple.screencapture disable-shadow -bool true # スクリーンキャプチャの影をなくす
defaults write com.apple.screencapture type -string "png" # スクリーンショットの保存形式を PNG にする
defaults write com.apple.screencapture location -string "~/Pictures/screenshot" # スクリーンショットの保存先
