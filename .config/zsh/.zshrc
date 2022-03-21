# ヒストリの設定
export HISTFILE=$XDG_CACHE_HOME/zsh/history
export HISTSIZE=1000000
export SAVEHIST=1000000

source $ZDOTDIR/options.zsh
source $ZDOTDIR/prompt.zsh
source $ZDOTDIR/plugins.zsh
source $ZDOTDIR/functions.zsh

# ローカルPCでだけ使いたい設定
[ -f ~/.local_functions.zsh ] && source ~/.local_functions.zsh

test -e "${ZDOTDIR}/.iterm2_shell_integration.zsh" && source "${ZDOTDIR}/.iterm2_shell_integration.zsh"

