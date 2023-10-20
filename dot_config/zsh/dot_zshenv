# profile
if [[ -v ZSHRC_PROFILE ]]; then
  zmodload zsh/zprof && zprof > /dev/null
fi

setopt no_global_rcs

unset PATH
unset MANPATH
eval $(/usr/libexec/path_helper -s)

export LANG=en_US.UTF-8
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
else
  eval $(/usr/local/bin/brew shellenv)
fi

path=(
    $HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin(N-/) # coreutils
    $HOMEBREW_PREFIX/opt/ed/libexec/gnubin(N-/) # ed
    $HOMEBREW_PREFIX/opt/findutils/libexec/gnubin(N-/) # findutils
    $HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin(N-/) # sed
    $HOMEBREW_PREFIX/opt/gnu-tar/libexec/gnubin(N-/) # tar
    $HOMEBREW_PREFIX/opt/grep/libexec/gnubin(N-/) # grep
    $HOMEBREW_PREFIX/opt/mysql-client/bin(N-/) # mysql
    ${path}
)
manpath=(
    $HOMEBREW_PREFIX/opt/coreutils/libexec/gnuman(N-/) # coreutils
    $HOMEBREW_PREFIX/opt/ed/libexec/gnuman(N-/) # ed
    $HOMEBREW_PREFIX/opt/findutils/libexec/gnuman(N-/) # findutils
    $HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnuman(N-/) # sed
    $HOMEBREW_PREFIX/opt/gnu-tar/libexec/gnuman(N-/) # tar
    $HOMEBREW_PREFIX/opt/grep/libexec/gnuman(N-/) # grep
    ${manpath}
)

fpath=($HOMEBREW_PREFIX/share/zsh/site-functions/(N-/) $fpath)

if [[ -e "$HOME/.local/share/zsh/completions" ]]; then
  fpath=($HOME/.local/share/zsh/completions/(N-/) $fpath)
fi

source $XDG_CONFIG_HOME/zsh/languages.zsh

# deduplicate
typeset -U path
typeset -U manpath
typeset -U fpath
