#!/bin/zsh

###
# 在宅・オフィス切り替え
###

# ネットワーク環境を切り替える
# https://qiita.com/fiftystorm36/items/5fe936a92445cbf4ad9a
# https://support.apple.com/ja-jp/HT202480
switchNetwork() {
  local location=$1

  scselect $(scselect | grep $location | awk '{ print $1 }')
}
switchSshConfig() {
  local location=$1
  case "$location" in
    Home)
      cp ~/.ssh/config.home ~/.ssh/config
      ;;
    Office)
      cp ~/.ssh/config.office ~/.ssh/config
      ;;
  esac
}
switchGitConfig() {
  local location=$1

  case "$location" in
    Home)
      git config --global --replace-all http.$GIT_REPO_URL_HTTPS.proxy $PROXY_URL
      git config --global --replace-all url.$GIT_REPO_URL_HTTPS.insteadOf $GIT_REPO_URL_SSH
      git config --global --replace-all url.$GIT_REPO_URL_HTTPS.insteadOf ssh://$GIT_REPO_URL_SSH --add
      ;;
    Office)
      git config --global --unset-all http.$GIT_REPO_URL_HTTPS.proxy
      git config --global --unset-all url.$GIT_REPO_URL_HTTPS.insteadOf
      ;;
  esac
}
switchMavenConfig() {
  local location=$1
  case "$location" in
    Home)
      cp ~/.m2/settings_home.xml ~/.m2/settings.xml
      ;;
    Office)
      cp ~/.m2/settings_office.xml ~/.m2/settings.xml
      ;;
  esac
}

main() {
  set -x
  sleep 5s

  airportpower=$(networksetup -getairportpower en0 | awk -F': ' '{ print $2 }')
  if test ${airportpower} = 'Off'; then
    echo 'Wifi is Off.'
    exit
  fi

  ssid=$(networksetup -getairportnetwork en0 | awk -F': ' '{ print $2 }')

  osascript -e 'display notification "'"SSID: $ssid, Home: $SSID_HOME, Office: $SSID_OFFICE"'" with title "'"switch_location"'" '

  location=Automatic
  case "$ssid" in
    $SSID_HOME)
      location=Home
      ;;
    $SSID_OFFICE)
      location=Office
      ;;
  esac

  currentLocation=$(networksetup -getcurrentlocation)
  if test $currentLocation = $location; then
    return
  fi
  osascript -e 'display notification "'"Switch network location to ${location}"'" with title "'"switch_location"'" '

  switchNetwork $location
  switchSshConfig $location
  switchGitConfig $location
  switchMavenConfig $location
  set +x
}

main
