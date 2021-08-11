# https://github.com/ulwlu/dotfiles/blob/master/system/macos.sh を参考にした

for i in $(find ./defaults -type f); do
  sh $i
done

killall cfprefsd
killall Dock
killall Finder
killall SystemUIServer
