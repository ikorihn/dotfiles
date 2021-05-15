# キーバインド
# emacs 風キーバインドにする
bindkey -e

# https://starship.rs/ja-jp/
eval "$(starship init zsh)"

# # powerlineを有効化
# powerline-daemon -q
# source ${POWERLINE_ROOT}/bindings/zsh/powerline.zsh

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

