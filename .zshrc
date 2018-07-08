# 環境変数
export LANG=ja_JP.UTF-8
export XDG_CONFIG_HOME=~/.config # NeoVim
export JAVA_HOME=`/System/Library/Frameworks/JavaVM.framework/Versions/A/Commands/java_home -v "1.8"`
export PATH=${JAVA_HOME}/bin:${PATH} # nodebrew
export PATH=$HOME/Library/Android/sdk/platform-tools:$PATH # Android Tool
export PATH=$HOME/.nodebrew/current/bin:${PATH} # nodebrew

export PATH=$(brew --prefix coreutils)/libexec/gnubin:$PATH # GNU
export MANPATH=$(brew --prefix coreutils)/libexec/gnuman:$MANPATH # GNU 

# 色を使用出来るようにする
autoload -Uz colors
colors

# powerlineを有効化
powerline-daemon -q
source /usr/local/lib/python3.7/site-packages/powerline/bindings/zsh/powerline.zsh

# キーバインド
# emacs 風キーバインドにする
bindkey -e
# ^R で履歴検索をするときに * でワイルドカードを使用出来るようにする
bindkey '^R' history-incremental-pattern-search-backward

# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# プロンプト
PROMPT="[%{%}%n]$ "
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:*' git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:*' formats "%F{green}%c%u[%b]%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd () { vcs_info }

RPROMPT="%{${fg[blue]}%}[%~]%{${reset_color}%}"
RPROMPT=$RPROMPT'${vcs_info_msg_0_}'

# 単語の区切り文字を指定する
autoload -Uz select-word-style
select-word-style default
# ここで指定した文字は単語区切りとみなされる
# / も区切りと扱うので、^W でディレクトリ１つ分を削除できる
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified

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
setopt ignore_eof

# '#' 以降をコメントとして扱う
setopt interactive_comments

# ディレクトリ名だけでcdする
setopt auto_cd

# cd したら自動的にpushdする
setopt auto_pushd
# 重複したディレクトリを追加しない
setopt pushd_ignore_dups

# 同時に起動したzshの間でヒストリを共有する
setopt share_history

# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups

# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space

# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks

# 高機能なワイルドカード展開を使用する
setopt extended_glob


########################################
# エイリアス

alias ls='ls --color=auto'
alias la='ls -a'
alias ll='ls -al'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias mkdir='mkdir -p'

alias python='python3'
alias pip='pip3'

# sudo の後のコマンドでエイリアスを有効にする
alias sudo='sudo '

# グローバルエイリアス
alias -g L='| less'
alias -g G='| grep'


########################################
# zplug
export ZPLUG_HOME=~/.zplug
source $ZPLUG_HOME/init.zsh

zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-history-substring-search"
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
zplug "b4b4r07/enhancd", use:init.sh
#zplug "yous/lime"
zplug "mollifier/cd-gitroot"

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
  local branches branch
  branches=$(git branch -vv) &&
  branch=$(echo "$branches" | fzf +m ) &&
  git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}
fbrm() {
  local branches branch
  branches=$(git branch -r | grep -v 'HEAD') &&
  branch=$(echo "$branches" | fzf +m ) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#origin/##")
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

fh() {
  eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}

# fvim
fvim() {
  local file
  file=$(find ${1:-.} -type f > /dev/null | fzf-tmux +m) &&
  nvim $file
}
