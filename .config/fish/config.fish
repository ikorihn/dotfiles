# powerlineを有効化
powerline-daemon -q
source $POWERLINE_ROOT/bindings/fish/powerline-setup.fish

########################################
# エイリアス

alias ls 'exa --group-directories-first'
alias ll 'ls -halF --git --time-style=long-iso'
alias la 'll -gHiS'

alias rm 'rm -i'
alias cp 'cp -i -p'
alias mv 'mv -i'

alias vim 'nvim'
alias view 'vim -R'

# zでfzf
alias zfzf 'cd (z -l | fzf | awk "{ print \$2 }")'
# sudo の後のコマンドでエイリアスを有効にする
alias sudo 'sudo '

alias ta 'todoist add -P 2227975550'
alias tl 'todoist --project-namespace --namespace --color list -f "#Work"'
alias tge 'toggl stop'

alias sourceconf 'source ~/.config/fish/config.fish'
alias sourceenv 'source ~/.config/fish/conf.d/000-env.fish'

########################################
# 関数
function fbr
  git branch -vv | fzf +m | awk '{print $1}' | sed "s/.* //" | xargs -I{} git switch {}
end

function fbrm
  git branch -r | grep -v 'HEAD' | fzf +m | sed "s/.* //" | sed "s#origin/##" | xargs -I{} git switch {}
end

function fbrd
  git branch -vv | fzf -m | awk '{print $1}' | sed "s/.* //" | xargs -I{} git branch -D {}
end

function gbr --description "Git browse commits"
    set -l log_line_to_hash "echo {} | grep -o '[a-f0-9]\{7\}' | head -1"
    set -l view_commit "$log_line_to_hash | xargs -I % sh -c 'git show --color=always % | diff-so-fancy | less -R'"
    set -l copy_commit_hash "$log_line_to_hash | xclip"
    set -l git_checkout "$log_line_to_hash | xargs -I % sh -c 'git checkout %'"
    set -l open_cmd "open"

    if test (uname) = Linux
        set open_cmd "xdg-open"
    end

    git log --graph --color=always --format='%C(auto)%h%d %s %C(green)%C(bold)%cr% C(blue)%an' | \
        fzf --no-sort --reverse --tiebreak=index --no-multi --ansi \
            --preview="$view_commit" \
            --header="ENTER to view, CTRL-Y to copy hash, CTRL-O to open on GitHub, CTRL-X to checkout, CTRL-C to exit" \
            --bind "enter:execute:$view_commit" \
            --bind "ctrl-y:execute:$copy_commit_hash" \
            --bind "ctrl-x:execute:$git_checkout"
end

function fadd
  git status --short |
  awk '{if (substr($0,2,1) !~ / /) print $2}' |
  fzf --bind "ctrl-d:execute:
              git diff --color=always {} | less -R
             " \
      --bind "ctrl-m:execute:
              git add {}
             "
end

function git_count
  set author $argv[1]
  set start_date $argv[2]
  set end_date $argv[3]
  git log --numstat --pretty="%H" --author="$author" --since=$start_date --until=$end_date --no-merges | awk 'NF==3 {plus+=$1; minus+=$2} END {printf("%d (+%d, -%d)\n", plus+minus, plus, minus)}'
end

function fvim
  set file (find . -type f | fzf-tmux +m)
  if [ -f "$file" ]
    nvim $file
  end
end

## Android
function adb_pull_file -d 'ファイルを取得する'
  set FILE_NAME $argv[1]
  set DIRECTORY $argv[2]
  if test -z $FILE_NAME
    or test -z $DIRECTORY
    echo 'no file'
    exit 1
  end
  adb pull /sdcard/$FILE_NAME $DIRECTORY/$FILE_NAME
  adb shell rm /sdcard/$FILE_NAME
end

function adb_screencap -d 'キャプチャを撮ってサイズを変更'
  set DATE_TIME (date +"%Y-%m-%dT%H-%M-%S")
  set FILE_NAME $DATE_TIME.png

  set DEST_DIR $argv[1]
  test -z $DEST_DIR; and set DEST_DIR ~/Desktop
  set SIZE $argv[2]
  test -z $SIZE; and set SIZE 300x

  adb shell screencap -p /sdcard/$FILE_NAME

  adb_pull_file $FILE_NAME $DEST_DIR

  mogrify -resize $SIZE -unsharp 2x1.4+0.5+0 -quality 100 -verbose $DEST_DIR/$FILE_NAME
end


function mp4_to_gif
  set FILE_NAME $argv[1]
  set DEST_FILE_NAME (echo $FILE_NAME | tr -d '.mp4')
  ffmpeg -i $FILE_NAME -an -r 15 -pix_fmt rgb24 -s 540x960 -f gif $DEST_FILE_NAME
end

function adb_screenrecord -d '画面録画'
  # function内のtrapがfunctionごと終了してしまって引っ掛けられないのでbash
  # https://github.com/fish-shell/fish-shell/issues/2036
  bash -c '
    DATE_TIME=$(date +"%Y-%m-%dT%H-%M-%S")
    FILE_NAME=$DATE_TIME.mp4

    DEST_DIR=${0:-~/Desktop}

    trap "echo \"pull to $DEST_DIR/$FILE_NAME\"; adb pull /sdcard/$FILE_NAME $DEST_DIR/$FILE_NAME; adb shell rm /sdcard/$FILE_NAME" SIGINT

    echo "録画を開始しました。録画を終了する場合は、 Ctrl+C を押下してください"
    adb shell screenrecord /sdcard/$FILE_NAME --size 540x960
  ' $argv[1]
end

function delete_DSStore
  find . -name ".DS_Store" -delete
end

function urldecode
  nkf -w --url-input
end

function urlencode
  nkf -WwMQ | sed 's/=$//g' | tr "=" "%" | tr -d "\n" |
    sed -e 's/%7E/~/g' \
        -e 's/%3D/=/g' \
        -e 's/%3F/?/g' \
        -e 's/%5F/_/g' \
        -e 's/%22/"/g' \
        -e 's/%2C/,/g' \
        -e 's/%2D/-/g' \
        -e 's/%2E/./g'
end

function urlsort
  tr "&" "\n" | tr "?" "\n" | sort
end

function history-merge --on-event fish_preexec
  history --save
  history --merge
end

function cd-gitroot
  if not git rev-parse --is-inside-work-tree > /dev/null 2>&1
    echo 'cd-gitroot: Not in a git repository'
    return 1
  end

  set -l root_path (git rev-parse --show-toplevel)
  set -l relative_path $argv[1]

  if test -z "$relative_path"
    cd -- $root_path
  else
    cd -- $root_path/$relative_path
  end
end

# JSON整形&上書き
function jformat
  set file $argv[1]
  set opt $argv[2]
  cat $file | jq '.' $opt > $file.tmp && mv $file.tmp $file
end

function distinct -d "Returns a set of the distinct elements of coll."
  set -l uniq
  for a in $argv
    if not contains $a $uniq
      set uniq $uniq $a
      echo $a
    end
  end
end

function multissh -d "SSH multiple server and send keys synchronously"
  set servers $argv
  while read -l line
    set servers $servers $line
  end
  test -z "$servers"; and return

  # set -l session
  # if test -n "$SESSION_NAME"
  #   set session $SESSION_NAME
  # else
  #   set session "multi-ssh-"(date +%s)
  # end
  # set window "multi-ssh"

  # # tmuxのセッションを作成
  # tmux new-session -d -n $window -s $session

  # 各ホストにsshログイン
  # 最初の1台はsshするだけ
  tmux send-keys "ssh $servers[1]" C-m
  # 残りはpaneを作成してからssh
  for i in $servers[2..-1]
    tmux split-window
    tmux select-layout tiled
    tmux send-keys "ssh $i" C-m
  end

  # 最初のpaneを選択状態にする
  tmux select-pane -t 0
  # paneの同期モードを設定
  tmux set-window-option synchronize-panes on
  # セッションにアタッチ
  # tmux attach-session -t $session
end

# Toggl, Todoist

function todoist_close
  set -l task (tl | fzf | awk '{ print $1 }')
  echo $task
  if [ -z $task ]
    return
  end
  todoist close $task
end

function tt -d 'start/stop toggl from todoist'
  todoist sync
  set current (toggl current)
  if test "$current" != "No time entry"
    echo "$current"
    read -p 'echo "stop it?(Y/n) > "' yn
    if test $yn = "n"
      echo "keep timer"
      return 0
    else
      toggl stop
    end
  end

  set selected_item_content (todoist --project-namespace --namespace --csv list -f '#Work' | fzf | cut -d ',' -f 6)
  if test -z $selected_item_content
    return 0
  end

  if test -n $selected_item_content
    echo "start $selected_item_content"
    toggl_start "$selected_item_content"
  end
end

function toggl_start
  set -l pj (toggl projects | fzf | awk '{ print $1 }')
  if [ -z $pj ]
    return
  end

  toggl start -P $pj $argv[1]
end

function toggl_status -d 'Togglのステータスを表示'
  if ! type -q toggl
    return
  end

  if [ (toggl --cache --csv current | head -n1) = "No time entry" ]
    echo -n "No time entry"
    return
  end

  set -l tgc_time (toggl --cache --csv current | grep Duration | cut -d ',' -f 2)
  set -l tgc_dsc (toggl --cache --csv current | grep Description | cut -d ',' -f 2 | cut -c 1-20)

  echo -n "$tgc_time $tgc_dsc"
end


test -e ~/.local_functions.fish; and source ~/.local_functions.fish
test -e ~/.iterm2_shell_integration.fish; and source ~/.iterm2_shell_integration.fish

# 補完 awscli
complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'
