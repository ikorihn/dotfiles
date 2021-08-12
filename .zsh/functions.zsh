########
# Git
########

fbr() {
  git branch -vv | fzf +m | awk '{print $1}' | sed "s/.* //" | xargs -I{} git switch {}
}

fbrm() {
  git branch -r | fzf +m | sed 's#^ *origin/##' | xargs -I{} git switch {}
}

fbrd() {
  git branch -vv | fzf -m | awk '{print $1}' | sed "s/.* //" | xargs -I{} git branch -D {}
}

# fshow - git commit browser
fgr() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
                FZF-EOF"
}

# Git browse commits
# gbr() {
#     log_line_to_hash="echo {} | grep -o '[a-f0-9]\{7\}' | head -1"
#     view_commit="$log_line_to_hash | xargs -I % sh -c 'git show --color=always % | diff-so-fancy | less -R'"
#     copy_commit_hash="$log_line_to_hash | xclip"
#     git_checkout="$log_line_to_hash | xargs -I % sh -c 'git checkout %'"
#     open_cmd="open"
# 
#     if [[ $(uname) = Linux ]];
#         set open_cmd "xdg-open"
#     fi
# 
#     git log --graph --color=always --format='%C(auto)%h%d %s %C(green)%C(bold)%cr% C(blue)%an' | \
#         fzf --no-sort --reverse --tiebreak=index --no-multi --ansi \
#             --preview="$view_commit" \
#             --header="ENTER to view, CTRL-Y to copy hash, CTRL-O to open on GitHub, CTRL-X to checkout, CTRL-C to exit" \
#             --bind "enter:execute:$view_commit" \
#             --bind "ctrl-y:execute:$copy_commit_hash" \
#             --bind "ctrl-x:execute:$git_checkout"
# }

# worktree移動
fwt() {
    # カレントディレクトリがGitリポジトリ上かどうか
    git rev-parse &>/dev/null
    if [ $? -ne 0 ]; then
        echo fatal: Not a git repository.
        return
    fi

    local selectedWorkTreeDir=`git worktree list | fzf +m | awk '{print $1}'`

    if [ "$selectedWorkTreeDir" = "" ]; then
        # Ctrl-C.
        return
    fi

    cd ${selectedWorkTreeDir}
}

# fcoc - checkout git commit
fcoc() {
  local commits commit
  commits=$(git log --pretty=oneline --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --tac +s +m -e) &&
  git checkout $(echo "$commit" | sed "s/ .*//")
}

fadd() {
  git status --short |
  awk '{if (substr($0,2,1) !~ / /) print $2}' |
  fzf --bind "ctrl-d:execute:
              git diff --color=always {} | less -R
             " \
      --bind "ctrl-m:execute:
              git add {}
             "
}

git_count() {
  local author
  local start_date
  local end_date
  author=$1
  start_date=$2
  end_date=$3
  git log --numstat --pretty="%H" --author="${author}" --since=${start_date} --until=${end_date} --no-merges | awk 'NF==3 {plus+=$1; minus+=$2} END {printf("%d (+%d, -%d)\n", plus+minus, plus, minus)}'
}

fh() {
  eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}

# fvim
fvim() {
  local file
  file=$(find . -name "${1:-*}" -type f > /dev/null | fzf-tmux +m) &&
  nvim $file
}


# ghq + cd
gcd() {
  local repo
  repo=$(ghq list -p | fzf)
  if [[ -z $repo ]]; then
    return
  fi
  cd $repo
  zle reset-prompt
}

########
# Android
########

# キャプチャを撮ってサイズを変更
adb_screencap() {
  local DATE_TIME=$(date +"%Y%m%d-%H%M%S")
  local FILE_NAME=${DATE_TIME}.png

  local DEST_DIR=${1:-~/Desktop}
  local SIZE=${2:-300x}

  adb shell screencap -p /sdcard/$FILE_NAME
  adb_pull_file $file_name $dest_dir

  mogrify -resize $SIZE -unsharp 2x1.4+0.5+0 -quality 100 -verbose $DEST_DIR/$FILE_NAME
}

adb_pull_file() {
  file_name=$1
  directory=$2
  if [[ -z $file_name -o -z $directory ]]; then
    echo 'no file'
    return 1
  fi

  adb pull /sdcard/$file_name $directory/$file_name
  adb shell rm /sdcard/$file_name
}

mp4_to_gif() {
  local FILE_NAME=$1
  local DEST_FILE_NAME=$(echo $FILE_NAME | tr -d '.mp4')
  ffmpeg -i $FILE_NAME -an -r 15 -pix_fmt rgb24 -s 540x960 -f gif $DEST_FILE_NAME
}

# https://github.com/fish-shell/fish-shell/issues/2036
adb_screenrecord() {
  local DATE_TIME=$(date +"%Y-%m-%dT%H-%M-%S")
  local FILE_NAME=$DATE_TIME.mp4
  local DEST_DIR=${1:-~/Desktop}

  trap "echo 'pull to $DEST_DIR/$FILE_NAME'; adb pull /sdcard/$FILE_NAME $DEST_DIR/$FILE_NAME; adb shell rm /sdcard/$FILE_NAME" SIGINT

  echo "録画を開始しました。録画を終了する場合は、 Ctrl+C を押下してください"
  adb shell screenrecord /sdcard/$FILE_NAME --size 540x960
}

########
# Util
########

delete_DSStore() {
  find . -name ".DS_Store" -delete
}

urldecode() {
  nkf -w --url-input
}

urlencode() {
  nkf -WwMQ | sed 's/=$//g' | tr "=" "%" | tr -d "\n" |
    sed -e 's/%7E/~/g' \
        -e 's/%3D/=/g' \
        -e 's/%3F/?/g' \
        -e 's/%5F/_/g' \
        -e 's/%22/"/g' \
        -e 's/%2C/,/g' \
        -e 's/%2D/-/g' \
        -e 's/%2E/./g'
}
urlsort() {
  tr "&" "\n" | tr "?" "\n" | sort
}

# JSON整形&上書き
jformat() {
  local file=$1
  local opt=$2
  cat $file | jq '.' $opt > $file.tmp && mv $file.tmp $file
}

distinct() {
#  set -l uniq
#  for a in $argv
#    if not contains $a $uniq
#      set uniq $uniq $a
#      echo $a
#    end
#  end
}

# SSH multiple server and send keys synchronously
multissh() {
  local servers=$*
  echo $servers
  while read server; do
    if [[ "$server" = "" ]]; then
      break
    fi
    servers="$servers $server"
  done
  test -z "$servers" && return
  echo $servers
  server_arr=(${=servers})

  # set -l session
  # if test -n "$SESSION_NAME"
  #   set session $SESSION_NAME
  # else
  #   set session "multi-ssh-"(date +%s)
  # end

  tmux new-window
  tmux rename-window "multi-ssh"

  # 各ホストにsshログイン
  # 最初の1台はsshするだけ
  tmux send-keys "ssh $server_arr[1]" C-m
  # 残りはpaneを作成してからssh

  for i in $server_arr[2,-1]; do
    tmux split-window
    tmux select-layout tiled
    tmux send-keys "ssh $i" C-m
  done

  # 最初のpaneを選択状態にする
  tmux select-pane -t 0
  # paneの同期モードを設定
  tmux set-window-option synchronize-panes on
  # セッションにアタッチ
  # tmux attach-session -t $session
}

# Toggl, Todoist

# function todoist_close
#   local task=$(tl | fzf | awk '{ print $1 }')
#   echo $task
#   if [ -z $task ]
#     return
#   end
#   todoist close $task
# end

# start/stop toggl from todoist
tt() {
  todoist sync
  # local current=$(toggl current)
  # if [[ "$current" != "No time entry" ]]; then
  #   echo "$current"
  #   echo "stop it?(y/N) "
  #   if read -q; then
  #     toggl stop
  #   else
  #     echo "keep timer"
  #     return 0
  #   fi
  # fi

  local selected_item_content=$(todoist --project-namespace --namespace --csv list -f '#Work' | fzf | cut -d ',' -f 6)
  if test -z $selected_item_content; then
    return 0
  fi

  if test -n $selected_item_content; then
    echo "start $selected_item_content"
    toggl_start "$selected_item_content"
  fi
}

toggl_start() {
  local pj=$(toggl projects ls -f name | fzf)
  if [ -z $pj ]; then
    return
  fi

  toggl start -o $pj $1
}

# Togglのステータスを表示
toggl_status() {
  # if [[ ! type -q toggl ]]; then
  #   return
  # fi

  current=$(toggl now)
  if [[ $(echo $current | wc -l) = 1 ]]; then
    echo -n "No time entry"
    return
  fi

  local tgc_time=$(echo $current | grep Duration | cut -d ':' -f 2-)
  local tgc_dsc=$(echo $current | head -1 | cut -d ' ' -f 1 | cut -c 1-20)

  echo -n "$tgc_time $tgc_dsc"
}

# クリップボード履歴を表示&fzfでコピー
cb() {
  copyq eval -- "tab('&clipboard'); for(i = 0; i < size(); i++) print(i + '\t' + str(read(i)).split('\n') + '\n');" | fzf -m | cut -f 1 | xargs -i copyq tab '&clipboard' read {} | pbcopy
}

########################################
# Bind keys
########################################
# widgetとして登録
zle -N gcd
# バインド
bindkey '^G^G' gcd
zle -N fbr
bindkey '^G^R' fbr
zle -N fbrm
bindkey '^G^M' fbrm

