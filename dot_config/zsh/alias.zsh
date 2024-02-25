alias ls='eza --group-directories-first'
alias ll='ls -halF --git --time-style=long-iso --icons=automatic'
alias la='ll -gHiS'

alias rm='trash'

# abbr rm='rm -i'
# abbr cp='cp -i -p'
# abbr mv='mv -i'
# abbr mkdir='mkdir -p'

alias vi='nvim'
# alias vim='/usr/local/bin/nvim'
alias vim='TERM=alacritty nvim'
alias view='vim -R'
alias vimdiff='nvim -d'

# sudo の後のコマンドでエイリアスを有効にする
alias sudo='sudo '

# クリップボードにコピーしつつ標準出力
alias teee='tee >(pbcopy)'

alias pwdd='pwd | sed "s#$HOME#\$HOME#"'
alias pbcopyy="tr -d '\n' | pbcopy"

abbr -S -q --force dc='cd' > /dev/null
abbr -S -q ':q'='exit'
abbr -S -q sel_firstcol="fzf +m | cut -d ' ' -f 1"
abbr -g -q null='>/dev/null 2>&1'
abbr -g -q pc='| pbcopy'
abbr -S -q vimcon='vim ~/.config/**'

# git
abbr -S -q g='git'
abbr -S -q gca='git commit --amend'
abbr -S -q gcim='git commit -m'
abbr -S -q gdn='git diff --name-status origin/master'
abbr -S -q gp='git pull --rebase --autostash'
abbr -S -q gpu='git push'
abbr -S -q gre='git rebase origin/master --autostash'
abbr -S -q gres='git restore .'
abbr -S -q grh='git reset HEAD\^'
abbr -S -q gs='git status'
abbr -S -q gsn='git show --name-status'
abbr -S -q gst='git stash'
abbr -S -q gstp='git stash pop'
abbr -S -q gsw='git switch -c feature/'
abbr -S -q t='tig'

