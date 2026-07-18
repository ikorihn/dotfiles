echo "$(date +%H%m%s) LAZY!!!"
########################################
# Lazy shell hooks
########################################
# 入力開始後でよい hook 類。PATH や即時 alias は sync.zsh 側に置く。
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# direnv
if command -v direnv 1>/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

# mise shims are added to PATH in .zshenv. The shell hook can wait until zle is idle.
if command -v mise 1>/dev/null 2>&1; then
  eval "$(mise activate zsh)"
elif [[ -f "$HOME/.local/bin/mise" ]]; then
  eval "$($HOME/.local/bin/mise activate zsh)"
fi

# zoxide
if command -v zoxide 1>/dev/null 2>&1; then
  export _ZO_DATA_DIR="${XDG_DATA_HOME}/zoxide"
  export _ZO_ECHO=1
  eval "$(zoxide init --cmd j zsh)"
fi

# https://github.com/k1LoW/git-wt
if command -v git-wt 1>/dev/null 2>&1; then
  eval "$(git wt --init zsh)"
fi

if command -v aqua 1>/dev/null 2>&1; then
  source <(aqua completion zsh)
fi

if command -v herdr 1>/dev/null 2>&1; then
  source <(herdr completion zsh)
fi

########################################
# Abbreviations
########################################
# zsh-abbr 読み込み後でよい展開設定。
#abbr -S -q -f rm='trash -F'
#abbr -S -q rmr='rm -r'

# abbr cp='cp -i -p'
# abbr mv='mv -i'
abbr -S -q -f mkdir='mkdir -p'

abbr -S -q --force dc='cd' > /dev/null
abbr -S -q ':q'='exit'
abbr -S -q -f 'ex'='exit'
abbr -S -q fzfcol="| fzf +m | cut -d ' ' -f 1"
abbr -g -q devnull='>/dev/null 2>&1'
abbr -g -q pc='| pbcopy'
abbr -g -q L='| less'
abbr -S -q vimcon='vim ~/.config/**'
abbr -g -q xn='| xargs nvim'

abbr -S -q lll='ll $(which'

abbr -S -q tcap="tmux capture-pane -p -S -32768 | nvim + -"

# クリップボードにコピーしつつ標準出力
abbr -S -q teee='tee >(pbcopy)'

# git
abbr -S -q g='git'
abbr -S -q gca='git commit --amend'
abbr -S -q gcim='git commit -m'
abbr -S -q gdn='git diff --name-status origin/master'
abbr -S -q gp='git pull --rebase --autostash --force'
abbr -S -q gpu='git push'
abbr -S -q gre='git rebase origin/master --autostash'
abbr -S -q gres='git restore .'
abbr -S -q grh='git reset HEAD\^'
abbr -S -q -f gs='git status'
abbr -S -q gsn='git show --name-status'
abbr -S -q gst='git stash'
abbr -S -q gstp='git stash pop'
abbr -S -q gsw='git switch -c feature/'
abbr -S -q t='tig'
abbr -S -q lg='lazygit'

# ripgrep,fd
# `!` はescapeされるためescape sequenceで定義 https://github.com/olets/zsh-abbr/issues/84#issuecomment-1475075037
abbr -S -q rgg="rg --glob='\041*{.pb.go,_test.go,mock_*.go,_gen.go}'"

#######
# zsh-completions
#######

# maven
zstyle ':completion:*:*:mvn:*:matches' group 'yes'
zstyle ':completion:*:*:mvn:*:options' description 'yes'
zstyle ':completion:*:*:mvn:*:options' auto-description '%d'
zstyle ':completion:*:*:mvn:*:descriptions' format $'\e[1m -- %d --\e[22m'
zstyle ':completion:*:*:mvn:*:messages' format $'\e[1m -- %d --\e[22m'
zstyle ':completion:*:*:mvn:*:warnings' format $'\e[1m -- No matches found --\e[22m'
maven_plugins=(dependency versions spotless)
zstyle ':completion:*:mvn:*' plugins $maven_plugins

# The next line enables shell command completion for gcloud.
if [ -f "${HOME}/src/google-cloud-sdk/completion.zsh.inc" ]; then
  source "${HOME}/src/google-cloud-sdk/completion.zsh.inc"
fi

# https://kubernetes.io/docs/tasks/tools/included/optional-kubectl-configs-zsh/
if command -v kubectl 1>/dev/null 2>&1; then
  # source <(kubectl completion zsh)
fi

# if command -v nerdctl 1>/dev/null 2>&1; then
#   source <(nerdctl completion zsh)
#   compdef _nerdctl nerdctl
# fi
source <(docker completion zsh)

autoload -U bashcompinit && bashcompinit

# https://github.com/go-jira/jira
if command -v jira 1>/dev/null 2>&1; then
  # eval "$(jira --completion-script-zsh)"
  _jira_bash_autocomplete() {
      local cur prev opts base
      COMPREPLY=()
      cur="${COMP_WORDS[COMP_CWORD]}"
      opts=$( ${COMP_WORDS[0]} --completion-bash ${COMP_WORDS[@]:1:$COMP_CWORD} )
      COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
      return 0
  }
  complete -F _jira_bash_autocomplete jira
fi

if [[ -f /opt/homebrew/bin/terraform ]]; then
  complete -o nospace -C /opt/homebrew/bin/terraform terraform
fi

# # AWS CLI v2
# autoload bashcompinit && bashcompinit
# autoload -Uz compinit && compinit
# compinit
# complete -C aws_completer aws

# bun completions
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

# pnpm
if command -v pnpm 1>/dev/null 2>&1; then
  source <(pnpm completion zsh)
fi

# uv
if command -v uv 1>/dev/null 2>&1; then
  eval "$(uv generate-shell-completion zsh)"
fi

if [[ -v WEZTERM_PANE ]]; then
  eval "$(wezterm shell-completion --shell zsh)"
fi

# # window名にgitリポジトリ名を表示する
# autoload -Uz add-zsh-hook
# autoload -Uz vcs_info
# zstyle ':vcs_info:*' enable git
# zstyle ':vcs_info:*' formats '%r'
# # precmd hook
# _precmd_tmux () {
#   if [[ -v TMUX ]]; then
#     tmux rename-window $(basename $(gitroot $(pwd)))
#   fi
# }
# 
# # wezterm
# function rename_wezterm_title {
#   # https://wezfurlong.org/wezterm/config/lua/pane/get_user_vars.html
#   # pane:get_user_vars().panetitle で取得できる
#   echo -n "\x1b]1337;SetUserVar=panetitle=$(echo -n $1 | base64)\x07"
#   # https://wezfurlong.org/wezterm/config/lua/pane/get_title.html
#   # pane:get_title() で取得できる
#   echo -n "\x1b]1;$(pwd)"
# }
# _precmd_wezterm () {
#   if [[ -v WEZTERM_PANE ]]; then
#     rename_wezterm_title $(basename $(gitroot $(pwd)))
#   fi
# }
# 
# add-zsh-hook precmd _precmd_tmux
# add-zsh-hook precmd _precmd_wezterm
