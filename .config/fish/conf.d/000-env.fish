set -U fish_user_paths /usr/local/bin /usr/bin /bin /usr/sbin /sbin

# NeoVim
set XDG_CONFIG_HOME ~/.config

# Java
set -xU JAVA_HOME (/System/Library/Frameworks/JavaVM.framework/Versions/A/Commands/java_home)
set -U fish_user_paths $JAVA_HOME/bin $fish_user_paths

# Android
set -xU ANDROID_SDK_HOME $HOME/Library/Android/sdk
set -U fish_user_paths $ANDROID_SDK_HOME/platform-tools $ANDROID_SDK_HOME/tools $fish_user_paths

# Node.js
set -U fish_user_paths $HOME/.nodebrew/current/bin $fish_user_paths

# Go
set -U fish_user_paths (go env GOPATH)/bin $fish_user_paths

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

set -U fish_user_paths \
    /usr/local/opt/coreutils/libexec/gnubin \
    /usr/local/opt/ed/libexec/gnubin \
    /usr/local/opt/findutils/libexec/gnubin \
    /usr/local/opt/gnu-sed/libexec/gnubin \
    /usr/local/opt/gnu-tar/libexec/gnubin \
    /usr/local/opt/grep/libexec/gnubin \
    $fish_user_paths

set -xU manpath \
    /usr/local/opt/coreutils/libexec/gnuman \
    /usr/local/opt/ed/libexec/gnuman \
    /usr/local/opt/findutils/libexec/gnuman \
    /usr/local/opt/gnu-sed/libexec/gnuman \
    /usr/local/opt/gnu-tar/libexec/gnuman \
    /usr/local/opt/grep/libexec/gnuman \
    $manpath

set -xU POWERLINE_ROOT (python -c 'import site; print (site.getsitepackages()[0])')/powerline

# https://github.com/jethrokuan/fzf#usage
set -U FZF_LEGACY_KEYBINDINGS 0
