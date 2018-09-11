setopt no_global_rcs # path_helperを無効化

export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

export LANG=ja_JP.UTF-8
export XDG_CONFIG_HOME=~/.config # NeoVim
export JAVA_HOME=`/System/Library/Frameworks/JavaVM.framework/Versions/A/Commands/java_home -v "1.8"`
export PATH=${PATH}:${JAVA_HOME}/bin # Java
export ANDROID_SDK_HOME="$HOME/Library/Android/sdk"
export PATH=$PATH:$ANDROID_SDK_HOME/platform-tools:$ANDROID_SDK_HOME/tools # Android Tool
export PATH=${PATH}:$HOME/.nodebrew/current/bin # nodebrew
export GOPATH=$HOME/go #go
export PATH=${PATH}:$GOPATH/bin

export PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH # GNU
export MANPATH=/usr/local/opt/coreutils/libexec/gnuman:$MANPATH # GNU 

export fpath=(~/.zsh/completion $fpath)

# The next line updates PATH for the Google Cloud SDK.
if [ -f '~/google-cloud-sdk/path.zsh.inc' ]; then source '~/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '~/google-cloud-sdk/completion.zsh.inc' ]; then source '~/google-cloud-sdk/completion.zsh.inc'; fi

export POWERLINE_ROOT="/usr/local/lib/python3.7/site-packages/powerline"
