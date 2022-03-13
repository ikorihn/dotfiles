### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/z-a-rust \
    zdharma-continuum/z-a-as-monitor \
    zdharma-continuum/z-a-patch-dl \
    zdharma-continuum/z-a-bin-gem-node

### End of Zinit's installer chunk


zinit ice wait'1' lucid; zinit light "zdharma-continuum/fast-syntax-highlighting"
zinit light "zsh-users/zsh-autosuggestions"
zinit light "zsh-users/zsh-completions"
zinit light "zsh-users/zsh-history-substring-search"
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

zinit ice wait'1' lucid pick'init.sh'; zinit light "b4b4r07/enhancd"
#zinit ice wait'1' lucid; zinit light "reegnz/jq-zsh-plugin"

zinit ice wait'1' lucid; zinit light "b4b4r07/emoji-cli"
zinit ice wait'1' lucid; zinit light "mollifier/cd-gitroot"
zinit light "Aloxaf/fzf-tab"

# Node.js
zinit ice wait'1' lucid; zinit light "lukechilds/zsh-nvm"
zinit ice wait'1' lucid; zinit light "lukechilds/zsh-better-npm-completion"


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

# docker
zinit lucid has'docker' for \
  as'completion' is-snippet \
  'https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker' \
  as'completion' is-snippet \
  'https://github.com/docker/compose/blob/master/contrib/completion/zsh/_docker-compose' \

# https://github.com/go-jira/jira
if command -v jira 1>/dev/null 2>&1; then
  eval "$(jira --completion-script-zsh)"
fi

#compdef toggl
_toggl() {
  eval $(env COMMANDLINE="${words[1,$CURRENT]}" _TOGGL_COMPLETE=complete-zsh  toggl)
}
if [[ "$(basename -- ${(%):-%x})" != "_toggl" ]]; then
  compdef _toggl toggl
fi

# # AWS CLI v2
# autoload bashcompinit && bashcompinit
# autoload -Uz compinit && compinit
# compinit
# complete -C aws_completer aws

# https://github.com/BurntSushi/ripgrep
zinit ice lucid as'completion' blockf has'rg'
zinit snippet $(brew --prefix)/share/zsh/site-functions/_rg

# https://github.com/sharkdp/fd
zinit ice lucid as'completion' blockf has'fd'
zinit snippet $(brew --prefix)/share/zsh/site-functions/_fd

# https://github.com/dandavison/delta/blob/master/etc/completion/completion.zsh
if command -v delta 1>/dev/null 2>&1; then
  compdef _gnu_generic delta
fi

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

