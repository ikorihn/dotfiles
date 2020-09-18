set -U fish_user_paths /usr/local/bin /usr/bin /bin /usr/sbin /sbin

# NeoVim
set XDG_CONFIG_HOME ~/.config

# Java
set -U JAVA_HOME (/System/Library/Frameworks/JavaVM.framework/Versions/A/Commands/java_home)
set -U fish_user_paths $JAVA_HOME/bin $fish_user_paths

# Android
set -U ANDROID_SDK_HOME $HOME/Library/Android/sdk
set -U fish_user_paths $fish_user_paths $ANDROID_SDK_HOME/platform-tools $ANDROID_SDK_HOME/tools

# Node.js
set -U fish_user_paths $HOME/.nodebrew/current/bin $fish_user_paths

# Go
set -U fish_user_paths (go env GOPATH)/bin $fish_user_paths
set -U GOPRIVATE "bitbucket.office.navitime.co.jp,alex.ntj.local"

# Python
if command -v pyenv 1>/dev/null 2>&1
  status --is-interactive; and source (pyenv init -|psub)
  set -U fish_user_paths $HOME/.pyenv/shims $fish_user_paths
  set -xU PIPENV_VENV_IN_PROJECT 1
end

# Ruby
if command -v rbenv 1>/dev/null 2>&1
  status --is-interactive; and source (rbenv init -|psub)
  set -U fish_user_paths $HOME/.rbenv/shims $fish_user_paths
end

# flutter
set -U fish_user_paths $HOME/flutter/bin $fish_user_paths

set -U fish_user_paths \
    /usr/local/opt/coreutils/libexec/gnubin \
    /usr/local/opt/ed/libexec/gnubin \
    /usr/local/opt/findutils/libexec/gnubin \
    /usr/local/opt/gnu-sed/libexec/gnubin \
    /usr/local/opt/gnu-tar/libexec/gnubin \
    /usr/local/opt/grep/libexec/gnubin \
    $fish_user_paths

set -x manpath \
    /usr/local/opt/coreutils/libexec/gnuman \
    /usr/local/opt/ed/libexec/gnuman \
    /usr/local/opt/findutils/libexec/gnuman \
    /usr/local/opt/gnu-sed/libexec/gnuman \
    /usr/local/opt/gnu-tar/libexec/gnuman \
    /usr/local/opt/grep/libexec/gnuman

set -xU POWERLINE_ROOT (python -c 'import site; print (site.getsitepackages()[0])')/powerline

# https://github.com/jethrokuan/fzf#usage
set -U FZF_LEGACY_KEYBINDINGS 0
set -U FZF_CTRL_T_COMMAND 'rg --files --hidden --follow --glob "!.git/*"'
set -U FZF_CTRL_T_OPTS '--preview "bat  --color=always --style=header,grid --line-range :100 {}"'
set -U FZF_COMPLETION_TRIGGER '~~'
set -U FZF_DEFAULT_COMMAND 'rg --hidden -g "!.git/*" -l ""'
