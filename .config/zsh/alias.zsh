alias ls='exa --group-directories-first'
alias ll='ls -halF --git --time-style=long-iso --icons'
alias la='ll -gHiS'

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

# # zでfzf
# abbr -S -q zfzf='cd (z -l | fzf | awk "{ print \$2 }")'

# # toggl
# abbr -S -q ta='todoist add -P 2227975550'
# abbr -S -q tl='todoist --project-namespace --namespace --color list -f "#Work"'
# abbr -S -q tge='toggl stop'

# fzf
abbr -S -q sel_firstcol="fzf +m | cut -d ' ' -f 1"

abbr -S -q vimcon='vim ~/.config/**'

# git
abbr -S -q gis='git status'
abbr -S -q gip='git pull'
abbr -S -q gipu='git push -u origin HEAD'
abbr -S -q gir='git rebase origin/master'
abbr -S -q gisn='git show --name-status'
abbr -S -q gisw='git switch -c feature/'
abbr -S -q gidn='git diff --name-status origin/master'
