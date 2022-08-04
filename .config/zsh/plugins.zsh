bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

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
  source <(kubectl completion zsh)
fi

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

#######
# https://github.com/Aloxaf/fzf-tab
#######
enable-fzf-tab
# zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
zstyle ':fzf-tab:*' fzf-bindings 'ctrl-j:accept' 'ctrl-a:toggle-all' 'ctrl-space:toggle+down'
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# preview directory's content with exa when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'

# https://github.com/junegunn/fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# https://starship.rs/ja-jp/
eval "$(starship init zsh)"

# bun completions
[ -s "~/.bun/_bun" ] && source "~/.bun/_bun"

# tmuxのwindow名にgitリポジトリ名を表示する
autoload -Uz add-zsh-hook
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' formats '%r'
# precmd hook
_tmux_precmd () {
  vcs_info
  if [[ -v TMUX ]]; then
    if [[ -n ${vcs_info_msg_0_} ]]; then
            tmux rename-window $vcs_info_msg_0_
    else
            tmux rename-window `basename $(pwd)`
    fi
  fi
}

add-zsh-hook precmd _tmux_precmd

