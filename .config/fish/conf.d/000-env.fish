set -U fish_user_paths /usr/local/bin /usr/local/sbin /usr/bin /bin /usr/sbin /sbin

# NeoVim
set -xU XDG_CONFIG_HOME ~/.config
set -xU EDITOR nvim

# Java
set -xU JAVA_HOME (/System/Library/Frameworks/JavaVM.framework/Versions/A/Commands/java_home)
set -U fish_user_paths $JAVA_HOME/bin $fish_user_paths

# Android
set -U ANDROID_SDK_HOME $HOME/Library/Android/sdk
set -U fish_user_paths $fish_user_paths $ANDROID_SDK_HOME/platform-tools $ANDROID_SDK_HOME/tools

# Node.js
set -U fish_user_paths $HOME/.nodebrew/current/bin $fish_user_paths

# Go
set -U fish_user_paths (go env GOPATH)/bin $fish_user_paths
# Rust
set -U fish_user_paths $HOME/.cargo/bin $fish_user_paths

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

# direnv
if command -v direnv 1>/dev/null 2>&1
  eval (direnv hook fish)
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

# https://github.com/oh-my-fish/theme-bobthefish
set -U theme_powerline_fonts no
set -U theme_nerd_fonts yes
set -U theme_newline_cursor yes
set -U theme_newline_prompt '$ '
set -U theme_display_user ssh
set -U theme_display_hostname ssh
set -U theme_display_vi yes
set -U theme_display_date yes
set -U theme_display_date yes
set -U theme_date_format "+%H:%M"
set -U theme_display_cmd_duration no
set -U theme_color_scheme dracula
set -U theme_title_display_process yes
set -U theme_title_use_abbreviated_path no

# https://github.com/jethrokuan/fzf#usage
# https://github.com/jethrokuan/fzf/issues/152 で使いづらいため終了
# set -U FZF_LEGACY_KEYBINDINGS 0
# set -U FZF_FIND_FILE_COMMAND 'fd --type file --hidden --follow --exclude .git'
# set -U FZF_OPEN_COMMAND 'fd --type file --hidden --follow --exclude .git'
# set -U FZF_CD_COMMAND 'fd --type directory --hidden --follow --exclude .git'
# set -U FZF_CD_WITH_HIDDEN_COMMAND 'fd --type directory --hidden --follow --exclude .git'
# set -U FZF_ENABLE_OPEN_PREVIEW 1
## set -U FZF_PREVIEW_FILE_CMD 'bat --color=always --style=header,grid --line-range :20'
# set -U FZF_PREVIEW_DIR_CMD 'ls'
# set -U FZF_TMUX 1
# set -U FZF_COMPLETE 3
# # https://github.com/junegunn/fzf#preview-window
# set -U FZF_DEFAULT_COMMAND 'fd --type file --hidden --follow --exclude .git'

# https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md#configuration-file
set -xU RIPGREP_CONFIG_PATH "$HOME/.ripgreprc"

# https://github.com/PatrickF1/fzf.fish
# set -U fzf_fish_custom_keybindings
set -U FZF_DEFAULT_OPTS '--height 40% --reverse --inline-info --preview "bat --color=always --style=header,grid --line-range :20 {}"'
