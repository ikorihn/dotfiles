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

# # zでfzf
# abbr -S -q zfzf='cd (z -l | fzf | awk "{ print \$2 }")'

# # toggl
# abbr -S -q ta='todoist add -P 2227975550'
# abbr -S -q tl='todoist --project-namespace --namespace --color list -f "#Work"'
# abbr -S -q tge='toggl stop'

abbr -S -q --force dc='cd' > /dev/null

abbr -S -q ':q'='exit'

# fzf
abbr -S -q sel_firstcol="fzf +m | cut -d ' ' -f 1"

abbr -S -q vimcon='vim ~/.config/**'

# git
abbr -S -q g='git'
abbr -S -q gca='git commit --amen'
abbr -S -q gdn='git diff --name-status origin/master'
abbr -S -q gp='git pull'
abbr -S -q --force gpr='git pull --rebase'
abbr -S -q gpu='git push'
abbr -S -q gre='git rebase origin/master'
abbr -S -q grh='git reset HEAD\^'
abbr -S -q gres='git restore .'
abbr -S -q gshn='git show --name-status'
abbr -S -q gst='git status'
abbr -S -q gsta='git stash'
abbr -S -q gstap='git stash pop'
abbr -S -q gsw='git switch -c feature/'
abbr -S -q t='tig'

