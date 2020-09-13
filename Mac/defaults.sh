for i in $(find ./defaults -type f); do
  sh $i
done

killall Finder
killall Dock
