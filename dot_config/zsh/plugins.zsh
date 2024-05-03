bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# mise (asdf rust impl)
if command -v mise 1>/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

# direnv
if command -v direnv 1>/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

# Bun(https://bun.sh)
if [[ -e "$HOME/.bun" ]]; then
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"
  source "$BUN_INSTALL/_bun"
fi

# zoxide
if command -v zoxide 1>/dev/null 2>&1; then
  export _ZO_DATA_DIR="${XDG_DATA_HOME}/zoxide"
  export _ZO_ECHO=1
  eval "$(zoxide init --cmd j zsh)"
fi

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

# https://kubernetes.io/docs/tasks/tools/included/optional-kubectl-configs-zsh/
if command -v kubectl 1>/dev/null 2>&1; then
  alias k=kubectl
  source <(kubectl completion zsh)
fi

if command -v nerdctl 1>/dev/null 2>&1; then
  source <(nerdctl completion zsh)
  compdef _nerdctl nerdctl
fi

source <(docker completion zsh)

# https://github.com/go-jira/jira
if command -v jira 1>/dev/null 2>&1; then
  # eval "$(jira --completion-script-zsh)"
  autoload -U bashcompinit && bashcompinit
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

# # AWS CLI v2
# autoload bashcompinit && bashcompinit
# autoload -Uz compinit && compinit
# compinit
# complete -C aws_completer aws

# bun completions
[ -s "~/.bun/_bun" ] && source "~/.bun/_bun"

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
