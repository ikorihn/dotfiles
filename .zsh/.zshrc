# 色を使用出来るようにする
autoload -Uz colors
colors

# # powerlineを有効化
# powerline-daemon -q
# source ${POWERLINE_ROOT}/bindings/zsh/powerline.zsh
# キーバインド
# emacs 風キーバインドにする
bindkey -e

# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# プロンプト
# PROMPT="[%~]$ "
# autoload -Uz vcs_info
# setopt prompt_subst
# zstyle ':vcs_info:*' git
# zstyle ':vcs_info:git:*' check-for-changes true
# zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
# zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
# zstyle ':vcs_info:*' formats "%F{green}%c%u[%b]%f"
# zstyle ':vcs_info:*' actionformats '[%b|%a]'
# precmd () { vcs_info }

# RPROMPT="%{${fg[blue]}%}[%~]%{${reset_color}%}"
# RPROMPT=$RPROMPT'${vcs_info_msg_0_}'

# 単語の区切り文字を指定する
autoload -Uz select-word-style
select-word-style default
# ここで指定した文字は単語区切りとみなされる
# / も区切りと扱うので、^W でディレクトリ１つ分を削除できる
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified

autoload -U zmv

########################################
# 補完
# 補完機能を有効にする
autoload -Uz compinit
compinit

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..

# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'

########################################
# オプション
# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# beep を無効にする
setopt no_beep

# フローコントロールを無効にする
setopt no_flow_control

# Ctrl+Dでzshを終了しない
# setopt ignore_eof

# '#' 以降をコメントとして扱う
setopt interactive_comments

# ディレクトリ名だけでcdする
# setopt auto_cd

# cd したら自動的にpushdする
setopt auto_pushd
# 重複したディレクトリを追加しない
setopt pushd_ignore_dups

# 同時に起動したzshの間でヒストリを共有する
setopt share_history
# ヒストリに実行時刻をつける
setopt extended_history

# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups

# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space

# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks

# histroyコマンドは記録しない
setopt hist_no_store

# 高機能なワイルドカード展開を使用する
setopt extended_glob

########################################
# エイリアス

alias ls='exa --group-directories-first'
alias ll='ls -halF --git --time-style=long-iso --icons'
alias la='ll -gHiS'

alias rm='rm -i'
alias cp='cp -i -p'
alias mv='mv -i'

alias mkdir='mkdir -p'

alias vim='nvim'
alias view='vim -R'
alias vimdiff='nvim -d'

# sudo の後のコマンドでエイリアスを有効にする
alias sudo='sudo '

# zでfzf
alias zfzf='cd (z -l | fzf | awk "{ print \$2 }")'

alias ta='todoist add -P 2227975550'
alias tl='todoist --project-namespace --namespace --color list -f "#Work"'
alias tge='toggl stop'
alias sourceconf='source ~/.config/fish/config.fish'
alias sourceenv='source ~/.config/fish/conf.d/000-env.fish'

########################################
# zplug
########################################
export ZPLUG_HOME=$(brew --prefix)/opt/zplug
source $ZPLUG_HOME/init.zsh

zplug "zsh-users/zsh-syntax-highlighting", defer:1
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-history-substring-search"
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
zplug "b4b4r07/enhancd", use:init.sh
#zplug "yous/lime"
zplug "mollifier/cd-gitroot"

zplug "lukechilds/zsh-better-npm-completion", defer:1

# 未インストール項目をインストールする
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# コマンドをリンクして、PATH に追加し、プラグインは読み込む
zplug load --verbose

########################################
# 開発設定
# Ruby
# eval "$(rbenv init -)"
# Java
# export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
########################################
# 関数
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

## Android
adb_screencap() {
  local DATE_TIME=`date +"%Y%m%d-%H%M%S"`
  local FILE_NAME=${DATE_TIME}.png

  adb shell screencap -p /sdcard/${FILE_NAME}
  pushd ~/Desktop
  adb pull /sdcard/${FILE_NAME}
  adb shell rm /sdcard/${FILE_NAME}

  mogrify -resize 300x -unsharp 2x1.4+0.5+0 \
          -colors 65 -quality 100 -verbose \
          ~/Desktop/${FILE_NAME}

  popd
}

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
  # while read -l line
  #   servers="$servers $line"
  # end
  test -z "$servers" && return

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
  for i in $servers[2..-1]; do
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
  local current=$(toggl current)
  if [[ "$current" != "No time entry" ]]; then
    echo "$current"
    read -p 'echo "stop it?(Y/n) > "' yn
    if [[ $yn = "n" ]]; then
      echo "keep timer"
      return 0
    else
      toggl stop
    fi
  fi

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
  local pj=$(toggl projects | fzf | awk '{ print $1 }')
  if [ -z $pj ]; then
    return
  fi

  toggl start -P $pj $1
}

# Togglのステータスを表示
toggl_status() {
  # if [[ ! type -q toggl ]]; then
  #   return
  # fi

  if [ $(toggl --cache --csv current | head -n1) = "No time entry" ]; then
    echo -n "No time entry"
    return
  fi

  local tgc_time=$(toggl --cache --csv current | grep Duration | cut -d ',' -f 2)
  local tgc_dsc=$(toggl --cache --csv current | grep Description | cut -d ',' -f 2 | cut -c 1-20)

  echo -n "$tgc_time $tgc_dsc"
}

# function cb -d 'クリップボード履歴を表示&fzfでコピー'
#   copyq eval -- "tab('&clipboard'); for(i = 0; i < size(); i++) print(i + '\t' + str(read(i)).split('\n') + '\n');" | fzf -m | cut -f 1 | xargs -i copyq tab '&clipboard' read {} | pbcopy
# end

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
bindkey '^G^M' fbr

########################################
# Other
########################################

source ~/.local_functions

# https://github.com/junegunn/fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# The next line updates PATH for the Google Cloud SDK.
if [ -f ~/google-cloud-sdk/path.zsh.inc ]; then source ~/google-cloud-sdk/path.zsh.inc; fi

# The next line enables shell command completion for gcloud.
if [ -f ~/google-cloud-sdk/completion.zsh.inc ]; then source ~/google-cloud-sdk/completion.zsh.inc; fi


test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# https://starship.rs/ja-jp/
eval "$(starship init zsh)"
