# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

# https://github.com/junegunn/fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# https://github.com/Aloxaf/fzf-tab
enable-fzf-tab
# zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
zstyle ':fzf-tab:*' fzf-bindings 'ctrl-j:accept' 'ctrl-a:toggle-all' 'ctrl-space:toggle+down'
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# preview a `git status` when completing git add
zstyle ':completion::*:git::git,add,*' fzf-completion-opts --preview='git -c color.status=always status --short'
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'

# fzf-tabを入れいているとFZF_COMPLETION_TRIGGERによるトリガーが効かなくなるため、ワークアラウンドとしてTAB2回で発動するようにする
# https://github.com/Aloxaf/fzf-tab/issues/65#issuecomment-1344970328
fzf-completion-notrigger() {
    # disable trigger just this once
    local FZF_COMPLETION_TRIGGER=""
    # if fzf-completion can't come up with something, call fzf-tab-complete
    # instead of the default completion widget (expand-or-complete).
    #
    # FIXME: triggers an infinite recursion on an empty prompt
    # _zsh_autosuggest_highlight_reset:3: maximum nested function level reached; increase FUNCNEST?
    #
    #local fzf_default_completion='fzf-tab-complete'
    fzf-completion "$@"
}
zle -N fzf-completion-notrigger

# Set an aggressive $KEYTIMEOUT to make usage of single <Tab> less miserable
KEYTIMEOUT=20
# Bind double <Tab>
bindkey '\t\t' fzf-completion-notrigger
# Bind Ctrl-Space in case I am unable to use double <Tab> due to a combination
# of the aggressive $KEYTIMEOUT on a slow link.
bindkey '^ ' fzf-completion-notrigger

