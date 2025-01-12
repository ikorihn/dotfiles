#!/data/data/com.termux/files/usr/bin/bash

cd $HOME/storage/shared/memo

git pull --autostash --rebase

git add -A
git commit -m "$(date +'%Y-%m-%d %H:%M:%S') from termux"

git push
