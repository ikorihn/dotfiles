#!/data/data/com.termux/files/usr/bin/bash

cd $HOME/storage/shared/memo
sed -e "s/{{date}}/$(date '+%Y-%m-%d')/" -e "s/{{time}}/$(date '+%H:%M')/" daily/daily_template.md > "daily/$(date '+%Y-%m-%d').md"
