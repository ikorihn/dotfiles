export MEMO_DIR=~/storage/shared/memo

alias ll='ls -al'
alias bashrc='vim ~/.bashrc'
alias sbashrc='source ~/.bashrc'
alias cdm="cd $MEMO_DIR"

alias gis='git status'
alias gia='git add .'
alias gip='git pull'

today() {
    date +"%Y-%m-%d"
}
now() {
    date +"%Y-%m-%d %H:%M:%S"
}

gic() {
    git commit -am "$(now) from termux"
}

allpush() {
    cdm
    git pull
    git add -A
    gic
    git push
}

alias ap=allpush
daily() {
    cp $MEMO_DIR/daily/daily_template.md $MEMO_DIR/daily/$(today).md
    sed -e "s/{{date}}/$(today)/g" -i $MEMO_DIR/daily/$(today).md
}

edaily() {
    vim $MEMO_DIR/daily/$(today).md
}

cdm && git pull
