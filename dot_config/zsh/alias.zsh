alias ls='eza --group-directories-first'
alias ll='ls -halF --git --time-style=long-iso --icons automatic'
alias la='ll -gHiS'

alias rm='trash'

# abbr rm='rm -i'
# abbr cp='cp -i -p'
# abbr mv='mv -i'
# abbr mkdir='mkdir -p'

alias vi='nvim'
alias vim='nvim'
alias view='vim -R'
alias vimdiff='nvim -d'

# sudo の後のコマンドでエイリアスを有効にする
alias sudo='sudo '

# クリップボードにコピーしつつ標準出力
alias teee='tee >(pbcopy)'

alias pwdd='pwd | sed "s#$HOME#\$HOME#"'
alias pbcopyy="tr -d '\n' | pbcopy"

