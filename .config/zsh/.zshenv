# profile
if [[ -v ZSHRC_PROFILE ]]; then
  zmodload zsh/zprof && zprof > /dev/null
fi

setopt no_global_rcs

unset PATH
unset MANPATH
eval $(/usr/libexec/path_helper -s)

export LANG=ja_JP.UTF-8
export XDG_CONFIG_HOME=~/.config
export XDG_CACHE_HOME=~/.cache
export XDG_DATA_HOME=~/.local/share
export XDG_STATE_HOME=~/.local/state
export EDITOR=nvim

path=($HOME/.local/bin(N-/) ${path})

# Homebrew
if [[ -e /opt/homebrew/bin/brew ]]; then
  # M1チップ
  unset HOMEBREW_SHELLENV_PREFIX
  eval $(/opt/homebrew/bin/brew shellenv)
  # export PATH=/opt/homebrew/bin:${PATH}
else
  eval $(/usr/local/bin/brew shellenv)
fi

export BREW_PREFIX=$(brew --prefix)
path=(
    $BREW_PREFIX/opt/coreutils/libexec/gnubin(N-/) # coreutils
    $BREW_PREFIX/opt/ed/libexec/gnubin(N-/) # ed
    $BREW_PREFIX/opt/findutils/libexec/gnubin(N-/) # findutils
    $BREW_PREFIX/opt/gnu-sed/libexec/gnubin(N-/) # sed
    $BREW_PREFIX/opt/gnu-tar/libexec/gnubin(N-/) # tar
    $BREW_PREFIX/opt/grep/libexec/gnubin(N-/) # grep
    $BREW_PREFIX/opt/mysql-client/bin(N-/) # mysql
    ${path}
)
manpath=(
    $BREW_PREFIX/opt/coreutils/libexec/gnuman(N-/) # coreutils
    $BREW_PREFIX/opt/ed/libexec/gnuman(N-/) # ed
    $BREW_PREFIX/opt/findutils/libexec/gnuman(N-/) # findutils
    $BREW_PREFIX/opt/gnu-sed/libexec/gnuman(N-/) # sed
    $BREW_PREFIX/opt/gnu-tar/libexec/gnuman(N-/) # tar
    $BREW_PREFIX/opt/grep/libexec/gnuman(N-/) # grep
    ${manpath}
)

fpath=($BREW_PREFIX/share/zsh/site-functions/(N-/) $fpath)

# Java
if command -v /usr/libexec/java_home 1>/dev/null 2>&1; then
  export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
  export PATH=${JAVA_HOME}/bin:${PATH}
fi

# Android
if [[ -e "$BREW_PREFIX/share/android-sdk" ]]; then
  export ANDROID_SDK_ROOT=$BREW_PREFIX/share/android-sdk
fi

# Go
if command -v go 1>/dev/null 2>&1; then
  export PATH=$(go env GOPATH)/bin:${PATH}
  export GOROOT=$(go env GOROOT)
fi

# Python
export PATH="$BREW_PREFIX/opt/python/libexec/bin:$PATH"
export PIPENV_VENV_IN_PROJECT=1
if [[ -e $HOME/.poetry/bin ]]; then
  export PATH="$HOME/.poetry/bin:$PATH"
fi

# Ruby
if [[ -e $HOME/.gem ]]; then
  export GEM_HOME=~/.gem
  export PATH="$HOME/.gem/bin:$PATH"
fi

# Rust
if [[ -e "$HOME/.cargo/env" ]]; then
  source "$HOME/.cargo/env"
fi

# Node.js(Volta)
if [[ -e "$HOME/.volta" ]]; then
  export VOLTA_HOME=$HOME/.volta
  export PATH="$VOLTA_HOME/bin:$PATH"
fi

if [[ -e "$HOME/.bun" ]]; then
   export BUN_INSTALL="$HOME/.bun"
   export PATH="$BUN_INSTALL/bin:$PATH"
fi

# direnv
if command -v direnv 1>/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

export POWERLINE_ROOT="$(python -c 'import site; print (site.getsitepackages()[0])')/powerline"

# ripgrep
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/config"

# fzf
export FZF_DEFAULT_COMMAND='fd --type file --hidden --follow --exclude .git'
# export FZF_DEFAULT_OPTS='--height 40% --reverse --inline-info --preview "bat --color=always --style=header,grid --line-range :20 {}"'
export FZF_CTRL_T_COMMAND='fd --type file --hidden --follow --exclude .git'

# vim
# export VIMINIT=":source $XDG_CONFIG_HOME/nvim/vimrc"

# deduplicate
typeset -U path
typeset -U manpath
typeset -U fpath
