setopt no_global_rcs

export LANG=ja_JP.UTF-8
export XDG_CONFIG_HOME=~/.config
export EDITOR=nvim
# ヒストリの設定
export HISTFILE=~/.zsh_history
export HISTSIZE=1000000
export SAVEHIST=1000000

# Homebrew
if [[ -e /opt/homebrew/bin/brew ]]; then
  # M1チップ
  eval $(/opt/homebrew/bin/brew shellenv)
else
  eval $(/usr/local/bin/brew shellenv)
fi

path=(
    $(brew --prefix)/opt/coreutils/libexec/gnubin(N-/) # coreutils
    $(brew --prefix)/opt/ed/libexec/gnubin(N-/) # ed
    $(brew --prefix)/opt/findutils/libexec/gnubin(N-/) # findutils
    $(brew --prefix)/opt/gnu-sed/libexec/gnubin(N-/) # sed
    $(brew --prefix)/opt/gnu-tar/libexec/gnubin(N-/) # tar
    $(brew --prefix)/opt/grep/libexec/gnubin(N-/) # grep
    ${path}
)
manpath=(
    $(brew --prefix)/opt/coreutils/libexec/gnuman(N-/) # coreutils
    $(brew --prefix)/opt/ed/libexec/gnuman(N-/) # ed
    $(brew --prefix)/opt/findutils/libexec/gnuman(N-/) # findutils
    $(brew --prefix)/opt/gnu-sed/libexec/gnuman(N-/) # sed
    $(brew --prefix)/opt/gnu-tar/libexec/gnuman(N-/) # tar
    $(brew --prefix)/opt/grep/libexec/gnuman(N-/) # grep
    ${MANPATH}
)

# Java
if [[ -e /System/Library/Frameworks/JavaVM.framework/Versions/A/Commands/java_home ]]; then
  export JAVA_HOME=$(/System/Library/Frameworks/JavaVM.framework/Versions/A/Commands/java_home)
  export PATH=${JAVA_HOME}/bin:${PATH}
fi

# Android
export ANDROID_SDK_HOME="$HOME/Library/Android/sdk"
export PATH=$ANDROID_SDK_HOME/platform-tools:$ANDROID_SDK_HOME/tools:$PATH # Android Tool

# Node.js
export PATH=$HOME/.nodebrew/current/bin:${PATH} # nodebrew

# Go
export PATH=$(go env GOPATH)/bin:${PATH}

# Python
if command -v pyenv 1>/dev/null 2>&1; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"

  eval "$(pyenv init -)"
  export PIPENV_VENV_IN_PROJECT=1
fi

# Ruby
if command -v rbenv 1>/dev/null 2>&1; then
  eval "$(rbenv init -)"
fi

# Rust
if [[ -e "$HOME/.cargo/env" ]]; then
  source "$HOME/.cargo/env"
fi

# direnv
if command -v direnv 1>/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

# flutter
if [[ -d "$HOME/flutter/bin" ]]; then
  export PATH=$HOME/flutter/bin:${PATH}
fi

export POWERLINE_ROOT="$(python -c 'import site; print (site.getsitepackages()[0])')/powerline"

# ripgrep
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# fzf
export FZF_DEFAULT_COMMAND='fd --type file --hidden --follow --exclude .git'
# export FZF_DEFAULT_OPTS='--height 40% --reverse --inline-info --preview "bat --color=always --style=header,grid --line-range :20 {}"'
