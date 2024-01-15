# Java
if command -v /usr/libexec/java_home 1>/dev/null 2>&1; then
  export JAVA_HOME=$(/usr/libexec/java_home -v 17)
  export PATH=${JAVA_HOME}/bin:${PATH}
fi

# Android
if [[ -e "$HOMEBREW_PREFIX/share/android-sdk" ]]; then
  export ANDROID_SDK_ROOT=$BREW_PREFIX/share/android-sdk
fi

# Go
export PATH=/usr/local/go/bin:${PATH}
if command -v go 1>/dev/null 2>&1; then
  export PATH=$HOME/go/bin:${PATH}
fi

# Python
export PATH="$HOMEBREW_PREFIX/opt/python/libexec/bin:$PATH"
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

# Rancher Desktop
if [[ -e "$HOME/.rd" ]]; then
   export PATH="$HOME/.rd/bin:$PATH"
fi

# ripgrep
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/config"

