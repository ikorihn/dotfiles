# powerlineを有効化
powerline-daemon -q
source $POWERLINE_ROOT/bindings/fish/powerline-setup.fish

########################################
# エイリアス

alias ls 'ls --color=auto -h'
alias ll 'ls -al'

alias rm 'rm -i'
alias cp 'cp -i -p'
alias mv 'mv -i'

alias vim 'nvim'
alias view 'vim -R'

# sudo の後のコマンドでエイリアスを有効にする
alias sudo 'sudo '


########################################
# 関数
function fbr
  git branch -vv | fzf +m | awk '{print $1}' | sed "s/.* //" | xargs -I{} git switch {}
end

function fbrm
  git branch -r | grep -v 'HEAD' | fzf +m | sed "s/.* //" | sed "s#origin/##" | xargs -I{} git switch {}
end

function fbrd
  git branch -vv | fzf -m | awk '{print $1}' | sed "s/.* //" | xargs -I{} git branch -D {}
end

function gbr --description "Git browse commits"
    set -l log_line_to_hash "echo {} | grep -o '[a-f0-9]\{7\}' | head -1"
    set -l view_commit "$log_line_to_hash | xargs -I % sh -c 'git show --color=always % | diff-so-fancy | less -R'"
    set -l copy_commit_hash "$log_line_to_hash | xclip"
    set -l git_checkout "$log_line_to_hash | xargs -I % sh -c 'git checkout %'"
    set -l open_cmd "open"

    if test (uname) = Linux
        set open_cmd "xdg-open"
    end

    git log --graph --color=always --format='%C(auto)%h%d %s %C(green)%C(bold)%cr% C(blue)%an' | \
        fzf --no-sort --reverse --tiebreak=index --no-multi --ansi \
            --preview="$view_commit" \
            --header="ENTER to view, CTRL-Y to copy hash, CTRL-O to open on GitHub, CTRL-X to checkout, CTRL-C to exit" \
            --bind "enter:execute:$view_commit" \
            --bind "ctrl-y:execute:$copy_commit_hash" \
            --bind "ctrl-x:execute:$git_checkout"
end

function fadd
  git status --short |
  awk '{if (substr($0,2,1) !~ / /) print $2}' |
  fzf --bind "ctrl-d:execute:
              git diff --color=always {} | less -R
             " \
      --bind "ctrl-m:execute:
              git add {}
             "
end

function git_count
  set author $argv[1]
  set start_date $argv[2]
  set end_date $argv[3]
  git log --numstat --pretty="%H" --author="$author" --since=$start_date --until=$end_date --no-merges | awk 'NF==3 {plus+=$1; minus+=$2} END {printf("%d (+%d, -%d)\n", plus+minus, plus, minus)}'
end

function fvim
  set file (find . -type f | fzf-tmux +m)
  if [ -f "$file" ]
    nvim $file
  end
end

## Android
function adb_screencap
  set DATE_TIME (date +"%Y-%m-%dT%H-%M-%S")
  set FILE_NAME $DATE_TIME.png
   
  adb shell screencap -p /sdcard/$FILE_NAME
  adb pull /sdcard/$FILE_NAME ~/Desktop/$FILE_NAME
  adb shell rm /sdcard/$FILE_NAME
   
  mogrify -resize 300x -unsharp 2x1.4+0.5+0 -colors 65 -quality 100 -verbose ~/Desktop/$FILE_NAME
end

function delete_DSStore
  find . -name ".DS_Store" -delete
end

function urldecode
  nkf -w --url-input
end

function urlencode
  nkf -WwMQ | sed 's/=$//g' | tr "=" "%" | tr -d "\n" |
    sed -e 's/%7E/~/g' \
        -e 's/%3D/=/g' \
        -e 's/%3F/?/g' \
        -e 's/%5F/_/g' \
        -e 's/%22/"/g' \
        -e 's/%2C/,/g' \
        -e 's/%2D/-/g' \
        -e 's/%2E/./g'
end

function urlsort
  tr "&" "\n" | tr "?" "\n" | sort
end

function history-merge --on-event fish_preexec
  history --save
  history --merge
end

function cd-gitroot
  if not git rev-parse --is-inside-work-tree > /dev/null 2>&1
    echo 'cd-gitroot: Not in a git repository'
    return 1
  end

  set -l root_path (git rev-parse --show-toplevel)
  set -l relative_path $argv[1]

  if test -z "$relative_path"
    cd -- $root_path
  else
    cd -- $root_path/$relative_path
  end
end

source ~/.local_functions.(basename $SHELL)
source ~/.iterm2_shell_integration.(basename $SHELL)
