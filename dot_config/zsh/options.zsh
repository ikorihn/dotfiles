# 色を使用出来るようにする
autoload -Uz colors
colors

# emacs 風キーバインドにする
bindkey -e

# ヒストリの設定
export HISTFILE=$XDG_CACHE_HOME/zsh/history
export HISTSIZE=50000
# export HISTORY_IGNORE="(ls|ll|cd|pwd|exit|cd *|ls *|ll *)"
export SAVEHIST=40000

# zsh historyに保存するときのhook
# https://superuser.com/questions/902241/how-to-make-zsh-not-store-failed-command
# ${(z)} は、zsh の配列を扱うための拡張機能の一つで、指定された文字列を特定の方法で分割して配列に格納するパラメータ展開 (parameter expansion)
zshaddhistory() {
  # 存在しないコマンドを保存しない
  local j=1
  local only_define=1
  for in in "${${(z)1}[@]}"; do
    whence ${${(z)1}[$j]} >| /dev/null && return 0
    if [[ ${in} == *=* || ${in} == "export" ]]; then
      ((j++))
    elif [[ ${in} == ";" ]]; then
      # ignore
    else
      only_define=0
    fi
  done
  if [[ ${only_define} -eq 1 ]]; then
    return 0
  fi

  command="${${(z)1}[$j]}"
  if [[ $command == \~* ]]; then
    command=${command//\~/${HOME}}
  fi
  if [[ -f ${command} ]]; then
    return 0
  fi
  whence ${command} >| /dev/null || return 1
}

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
########################################

# sheldonで補完機能を有効にしているため不要
# autoload -Uz compinit
# compinit

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..

# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'

########################################
# setopt
########################################

# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# beep を無効にする
setopt no_beep

# フローコントロールを無効にする
setopt no_flow_control

# Ctrl+Dでzshを終了しない
setopt ignore_eof

# '#' 以降をコメントとして扱う
setopt interactive_comments

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

# historyコマンドは記録しない
# setopt hist_no_store

# 高機能なワイルドカード展開を使用する
setopt extended_glob

# 明確なドットの指定なしで.から始まるファイルをマッチ
setopt globdots
