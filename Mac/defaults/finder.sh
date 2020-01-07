sudo chflags nohidden /Volumes    # /Volumes ディレクトリを見えるようにする
chflags nohidden ~/Library    # ~/Library ディレクトリを見えるようにする
defaults write com.apple.finder AnimateWindowZoom -bool false    # フォルダを開くときのアニメーションを無効にする
defaults write com.apple.finder AppleShowAllFiles YES    # 不可視ファイルを表示する
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"    # 検索時にデフォルトでカレントディレクトリを検索する
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false    # 拡張子変更時の警告を無効化する
defaults write com.apple.Finder FXPreferredViewStyle Nlsv    # 常にリストビューにする
defaults write com.apple.finder NewWindowTarget -string "PfHm" # 新しいウィンドウでデフォルトでホームフォルダを開く
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/" # 新しいウィンドウでデフォルトでホームフォルダを開く
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true # マウントされたディスクがあったら、自動的に新しいウィンドウを開く
defaults write com.apple.finder QLEnableTextSelection -bool true    # クイックルックでテキストを選択可能にする
defaults write com.apple.finder QuitMenuItem -bool true    # Finder を終了させる項目を追加する
defaults write com.apple.finder ShowPathbar -bool true    # パスバーを表示する
defaults write com.apple.finder ShowStatusBar -bool true    # ステータスバーを表示する
defaults write com.apple.finder ShowTabView -bool true    # タブバーを表示する
defaults write com.apple.finder WarnOnEmptyTrash -bool false    # ゴミ箱を空にする前の警告を無効化する
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true    # Finder のタイトルバーにフルパスを表示する
defaults write com.apple.finder _FXSortFoldersFirst -bool true    # 名前で並べ替えを選択時にディレクトリを前に置くようにする
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true

