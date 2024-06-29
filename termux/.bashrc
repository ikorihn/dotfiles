export MEMO_DIR=~/storage/shared/memo
export EDITOR=vim

export SVDIR=$PREFIX/var/service
export LOGDIR=$PREFIX/var/log
service-daemon start

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

recreaterepo() {
    rm -rf .git
    git init
    git remote add origin git@github.com:ikorihn/memo.git
    git fetch origin
    git switch -f master
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
