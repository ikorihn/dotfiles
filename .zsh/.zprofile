alias ls='exa --group-directories-first'
alias ll='ls -halF --git --time-style=long-iso --icons'
alias la='ll -gHiS'

# alias rm='rm -i'
# alias cp='cp -i -p'
# alias mv='mv -i'

alias mkdir='mkdir -p'

alias vi='nvim'
alias vim='nvim'
alias view='vim -R'
alias vimdiff='nvim -d'

# sudo の後のコマンドでエイリアスを有効にする
alias sudo='sudo '

# zでfzf
alias zfzf='cd (z -l | fzf | awk "{ print \$2 }")'

# toggl
alias ta='todoist add -P 2227975550'
alias tl='todoist --project-namespace --namespace --color list -f "#Work"'
alias tge='toggl stop'

# fzf
alias sel_firstcol="fzf +m | cut -d ' ' -f 1"
