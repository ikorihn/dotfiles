autoload -Uz compinit
if [[ -n $(find ${ZDOTDIR}/.zcompdump -mtime +1) ]] ; then
  compinit
else
  compinit -C
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

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

# https://github.com/jeffreytse/zsh-vi-mode?tab=readme-ov-file#configuration-function
function zvm_config() {
  ZVM_READKEY_ENGINE=$ZVM_READKEY_ENGINE_NEX
  ZVM_KEYTIMEOUT=0.1
  ZVM_ESCAPE_KEYTIMEOUT=0.01
  ZVM_VI_ESCAPE_BINDKEY=jk
  ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
  ZVM_VI_VISUAL_ESCAPE_BINDKEY=i
}

# https://github.com/jeffreytse/zsh-vi-mode#execute-extra-commands
# The plugin will auto execute this zvm_after_init function
function zvm_after_init() {

  # https://github.com/junegunn/fzf
  # 読み込みタイミングによってfzf-tabからファイルを選択するとshellが終了してしまうので早めにロードする
  # 例) shell起動 -> vim <tabでファイル選択> -> ファイルを選んでエンターするとshellが落ちる
  source <(fzf --zsh)
  export FZF_DEFAULT_COMMAND='fd --type file --hidden --follow --exclude .git'
  export FZF_DEFAULT_OPTS='--multi --reverse --inline-info'
  export FZF_CTRL_R_OPTS=$(cat <<'EOS'
    --preview "echo {} | sed -r 's/^ *[^ ]* *//' | bat --color=always --language=sh --style=plain"
    --preview-window 'down,40%,wrap'
    --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
    --header 'Press CTRL-Y to copy command into clipboard'
EOS
  )
  export FZF_ALT_C_OPTS="--preview 'eza -T -L 1 {}'"
  export FZF_CTRL_T_COMMAND='fd --type file --hidden --follow --exclude .git'
  export FZF_CTRL_T_OPTS='--preview "bat --color=always --style=header,grid --line-range :100 {}"'
  export FZF_TMUX=1
  export FZF_TMUX_OPTS='-p 90%,80%'

  # https://github.com/Aloxaf/fzf-tab
  enable-fzf-tab
  # zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
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

  zle -N fzf-completion-notrigger

  # Set an aggressive $KEYTIMEOUT to make usage of single <Tab> less miserable
  KEYTIMEOUT=20
  # Bind double <Tab>
  bindkey '\t\t' fzf-completion-notrigger
  # Bind Ctrl-Space in case I am unable to use double <Tab> due to a combination
  # of the aggressive $KEYTIMEOUT on a slow link.
  bindkey '^ ' fzf-completion-notrigger

}
