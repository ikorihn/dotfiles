setopt no_global_rcs # path_helperを無効化

export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

export LANG=ja_JP.UTF-8
# NeoVim
export XDG_CONFIG_HOME=~/.config
# Java
export JAVA_HOME=$(/System/Library/Frameworks/JavaVM.framework/Versions/A/Commands/java_home)
export PATH=${PATH}:${JAVA_HOME}/bin

export ANDROID_SDK_HOME="$HOME/Library/Android/sdk"
export PATH=$PATH:$ANDROID_SDK_HOME/platform-tools:$ANDROID_SDK_HOME/tools # Android Tool

export PATH=${PATH}:$HOME/.nodebrew/current/bin # nodebrew

#go
export GOPATH=$HOME/go
export PATH=${PATH}:$GOPATH/bin

path=(
    /usr/local/opt/python3/libexec/bin(N-/)
    /usr/local/opt/coreutils/libexec/gnubin(N-/) # coreutils
    /usr/local/opt/ed/libexec/gnubin(N-/) # ed
    /usr/local/opt/findutils/libexec/gnubin(N-/) # findutils
    /usr/local/opt/gnu-sed/libexec/gnubin(N-/) # sed
    /usr/local/opt/gnu-tar/libexec/gnubin(N-/) # tar
    /usr/local/opt/grep/libexec/gnubin(N-/) # grep
    ${path}
)
manpath=(
    /usr/local/opt/coreutils/libexec/gnuman(N-/) # coreutils
    /usr/local/opt/ed/libexec/gnuman(N-/) # ed
    /usr/local/opt/findutils/libexec/gnuman(N-/) # findutils
    /usr/local/opt/gnu-sed/libexec/gnuman(N-/) # sed
    /usr/local/opt/gnu-tar/libexec/gnuman(N-/) # tar
    /usr/local/opt/grep/libexec/gnuman(N-/) # grep
    ${manpath}
)

export fpath=(~/.zsh/completion $fpath)

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
export PIPENV_VENV_IN_PROJECT=1

export POWERLINE_ROOT="/usr/local/lib/python3.7/site-packages/powerline"

